#!/bin/bash -p

# $Id: cups-import-printer,v 1.14 2018/01/08 13:04:53 fm Exp $

PATH=/usr/bin/gnu:/sbin:/bin:/etc:/usr/sbin:/usr/bin:/usr/etc

cups_server=cups-sam.inria.fr
current_printers='printer-bw-sam printer-color-sam'

# lpstat is a wrapper at Sophia ...
lpstat=$(type -p lpstat.cups || echo lpstat)

# TODOs:
#  - option --direct: pour utiliser le device fourni par cups_server
#    Cf find_device plus bas

usage() {
    echo "\
Usage: ${0##*/} [<options>] [<printer names>]

  Import printers from the $cups_server CUPS server on the local
  machine.

  Note: on MacOS, forces the protocol to use to SMB instead of LPD
        That will permit to authenticate using INRIA login name and
        password.

  Arguments: 
    Printer names on $cups_server. You can get those names at the URL:

      https://$cups_server:631/printers

    or use the -l option. See below.

  Options:

    --help                         This help.
    -n,--dry-run                   Shows only what would be done.
    -l,--location <pattern>        Import all the printers those
                                   location contain a given pattern
                                   Case insensitive match

  Examples:
     Import all the printers located in the Cauchy building:

         $0 -l cauchy

     Import the current virtual printers:

         $0 $current_printers
"
    exit 0
}

main() {
    local location

    while (($# > 0)); do
        case $1 in
            --help )
                usage
                ;;
            -n | --dry-run )
                export DONT=true
                ;;
            -l | --location )
                (($# >= 2 )) || { bad_usage "$0" "$1"; return 1; }
                location=$2
                shift
                ;;

            -* )
                bad_usage "$0" "unknown option: $1"
                return 2
                ;;
            * )
                break
                ;;
        esac
        shift
    done
    local -a printers=("$@")
    if [ "$location" ]; then
        set -- $(find_printers $location)
        if (($# == 0)); then
            echo >&2 "*** Error: no printer location matches $location. Aborting"
            return 1
        fi
        printers=("$@" "${printers[@]}")
    fi

    if ((${#printers[@]} == 0)); then
        bad_usage "$0" "No printer names given"
        return 1
    fi

    if [ "$DONT" ]; then
        echo '## Note: DRY-RUN mode'
    fi
    for printer in "${printers[@]}"; do
        # Note: l'option -h de lpstat pour specifier le serveur cups
        #       ne marche pas :-(
        local status="$(CUPS_SERVER=$cups_server $lpstat -l -p $printer)"
        
        local sp=$'[ \t]*' # Vive perl
        local description=$(echo "$status" \
            | sed -n "s/^${sp}Description${sp}:${sp}//p")
        local location=$(echo "$status" \
            | sed -n  -e "s/^${sp}Location${sp}:${sp}//p" \
                      -e "s/^${sp}Emplacement${sp}:${sp}//p" \
                      -e "s/^${sp}Lieu${sp}:${sp}//p" \
            )
        if [ -z "$description" ]; then
            echo >&2 "*** Error: no description for $printer on $cups_server. Skipped"
            echo >&2 '*** --- $lpstat output ---'
            echo "$status" | sed 's/^/*** /' >&2
            echo >&2 '*** --- end $lpstat output ---'
            continue
        fi
        if [ -z "$location" ]; then
            echo >&2 "*** Error: no location for $printer on $cups_server. Skipped"
            echo >&2 '*** --- $lpstat output ---'
            echo "$status" | sed 's/^/*** /' >&2
            echo >&2 '*** --- end $lpstat output ---'
            continue
        fi
        local device=$(find_device $cups_server $printer)
        if [ -x  /bin/launchctl ]; then
            # Cas MacOS: anti: /var/log/cups/error_log: E ... Invalid printer name
            #  Utiliser les noms de serveurs en ad.inria.fr
            if [[ "$device" == *.inria.fr* ]] && ! [[ "$device" == *.ad.inria.fr* ]]; then
                device=${device/.inria.fr/.ad.inria.fr}
            fi
        fi
        echo "## Adding printer $printer. Destination: $device"
        # "lpadmin -P" ne met pas en place le PPD en Mountain Lion :-(
        #   => on l'installe directement, et *avant* la creation via lpadmin
        #      qui suit sous peine de non prise en compte en Linux 
        #      F19 cups-1.6.4.
        curl --silent http://$cups_server:631/printers/$printer.ppd \
            | grep -vi cupsfilter \
            > /tmp/$printer.ppd
        dont cp /tmp/$printer.ppd /etc/cups/ppd

        dont_lpadmin \
            -o printer-is-shared=false \
            -p $printer \
            -E \
            -D "$description" \
            -L "$location" \
            -v $device


    done
    # MacOs
    if [ -z "$DONT" ]; then
        if [ -x  /bin/launchctl ]; then
            echo "## Restarting org.cups.cupsd with launchctl"
            /bin/launchctl stop org.cups.cupsd
            fix_smb_printers $cups_server "${printers[@]}"
            /bin/launchctl start org.cups.cupsd
        fi
    fi
    return 0
}

## Fonctions locales

fix_smb_printers () {
    # Assume cupsd is *not* running
    local cups_server=$1
    shift
    local printer
    local sed_scrpt
    for printer in "$@"; do
        if [[ "$(find_device $cups_server $printer)" == smb:* ]]; then
            sed_scrpt="
$sed_scrpt
/<Printer $printer>/a\\
AuthInfoRequired username,password\\

"
        fi
    done
    if [ "$sed_scrpt" ]; then
        sed -i .bak "$sed_scrpt" /etc/cups/printers.conf
    fi
}

find_device () {
    local cups_server=$1
    local printer=$2
    local device=$(CUPS_SERVER=$cups_server $lpstat -v $printer)
    device=${device#*:\ }
    # printers Papercut sur MacOs (Darwin)
    case "$printer" in
        printer-color-* | printer-bw-* )
            # PaperCut: assume lpd:// :-(
            if [ "$(uname -s)" = Darwin ]; then
                # Sur les Mac on passe en smb (authentification).
                echo ${device/lpd:/smb:}
            else
                echo $device
            fi
            ;;
        * )
            # Pre PaperCut
            #   Heuristique: si le device est lpd on le prend (server reel), sinon
            #   on force cups_server.
            if [[ "$device" == lpd* ]]; then
                echo $device
            else
                echo ipp://$cups_server/printers/$printer
            fi
            ;;
    esac
}

dont_lpadmin () {
    if [ "$DONT" ]; then
        echo -n lpadmin
        for i; do
            if [[ "$i" == *\ * ]]; then
                echo -n " '$i'"
            else
                echo -n " $i"
            fi
        done
        echo
    else
        lpadmin "$@"
    fi
}

find_printers () {
    local location=$1
    # HOME anti ~/.cups/lpoptions
    HOME=/unknown CUPS_SERVER=$cups_server $lpstat -l -p \
    | (
        shopt -s nocasematch
        printer=
        # IFS= pour ne pas supprimer les blancs initiaux
        while IFS= read line; do
            case $line in 
                *type*imprimante* | *printer*types* )
                    ;;
                *imprimante* )
                    set -- ${line#*imprimante}
                    printer=$1
                    ;;
                printer* )
                    # Pas *printer* anti: Printer is unreachable
                    set -- ${line#*printer}
                    printer=$1
                    ;;
                *Emplacement*$location* | *Location*$location*)
                    echo $printer
                    ;;
            esac

        done
    )
}

## Fonctions communes

# $FromId: dont,v 1.3 2004/04/23 11:46:07 root Exp $

# Pour ne faire que echoer les commandes devant etre execute'es
# si la variable DONT a ete positionne'e
dont () {
    if [ "$DONT" ]
    then
	echo "$@"
    else
	"$@"
    fi
}

# $FromId: bad_usage,v 1.1 2006/02/27 07:35:16 fm Exp $

bad_usage () {
    local name=$1
    shift
    echo >&2 "\
** ${name##*/}: Bad usage: $*
** Cf: $name --help"
}
## Debug
[[ $0 == *bash ]] && return

## Main
main "$@"

#-------------------- emacs mode
# Pas de tab svp, <tab> == completion si on colle dans un shell interactif

# Local Variables: ***
# indent-tabs-mode: nil ***
# End: ***
