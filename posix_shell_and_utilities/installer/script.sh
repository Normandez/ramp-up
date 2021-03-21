#!/bin/bash

TAR_MARK="#__#"
SHABANG="#!/bin/bash"
INSTALLER_SH="\
OPTION_INSTALL=\"-I\"
OPTION_UNINSTALL=\"-U\"
OPTION_REINSTALL=\"-R\"
TAR_MARK=\"${TAR_MARK}\"
FILE_SETTINGS=\"\${HOME}/.my-settings\"
FILE_SETTINGS_OLD=\"\${FILE_SETTINGS}.old\"
function help()
{
    echo \"Usage:\"
    echo \"    INSTALL:   \$0 \${OPTION_INSTALL} [<dir_to_install>]\"
    echo \"    UNINSTALL: \$0 \${OPTION_UNINSTALL}\"
    echo \"    REINSTALL: \$0 \${OPTION_INSTALL} [<dir_to_install>] \${OPTION_REINSTALL}\"
}
function install()
{
    if [ -f \"\${FILE_SETTINGS}\" ];
    then
        cp -f \"\${FILE_SETTINGS}\" \"\${FILE_SETTINGS_OLD}\"
        if [ \$3 == true ];
        then
            uninstall true
        fi
    fi
    echo \"installing...\"
    sed -n \"/^\${TAR_MARK}/,\\\$p\" \"\$1\" | tail -n +2 | tar -xz -C \"\$2\"
    echo \"installed: \$2\"
    echo \"\$2\" > \"\${FILE_SETTINGS}\"
}
function uninstall()
{
    echo \"uninstalling...\"
    if [ -f \"\${FILE_SETTINGS}\" ];
    then
        rm -r \$(cat \"\${FILE_SETTINGS}\")/\${ARCHIVE_ENTRY}
        if [ \$? != 0 ];
        then
            echo \"error: cannot uninstall\"
            exit 3
        fi
        echo \"uninstalled: \$(cat \${FILE_SETTINGS})\"
        rm \"\${FILE_SETTINGS}\"
    else
        echo \"note: already uninstalled\"
    fi
    if [ \$# == 0 ] && [ -f \${FILE_SETTINGS_OLD} ];
    then
        rm \"\${FILE_SETTINGS_OLD}\"
    fi
}
if [ \$# > 0 ];
then
    if [ \"\$1\" == \"\${OPTION_INSTALL}\" ];
    then
        reinstall=false
        install_dir=\"\${HOME}/local\"
        if [ \$# -ge 2 ];
        then
            if [ \"\$2\" == \"\${OPTION_REINSTALL}\" ];
            then
                reinstall=true
            else
                install_dir=\$2
            fi
        fi
        if [ ! -d \"\$install_dir\" ];
        then
            mkdir \"\$install_dir\"
            if [ \$? != 0 ];
            then
                echo \"error: cannot create: '\${install_dir}'\"
                exit 2
            fi
        fi
        if [ \$# -ge 3 ];
        then
            if [ \"\$3\" == \"\${OPTION_REINSTALL}\" ];
            then
                reinstall=true
            else
                echo \"error: unrecognized option: '\$3'\"
                help
                exit 1
            fi
        fi
        install \"\$0\" \"\$install_dir\" \$reinstall
        echo \"completed\"
    elif [ \"\$1\" == \"\${OPTION_UNINSTALL}\" ];
    then
        uninstall
        echo \"completed\"
    else
        help
        exit 1
    fi
else
    help
    exit 1
fi
exit 0

"

function help()
{
    echo "Usage:"
    echo "    $0 <file_or_dir_to_compress>"
}

# main
if [ $# == 1 ];
then
    if [[ -d "$1" ]] || [[ -f "$1" ]];
    then
        echo "creating installer..."

        installer="installer_"$(basename "$1")".sh"
        echo "${SHABANG}" > "$installer"
        echo "ARCHIVE_ENTRY=\"$(basename "$1")"\" >> "$installer"
        echo "${INSTALLER_SH}" >> "$installer"
        echo "$TAR_MARK" >> "$installer"
        tar -cz "$1" >> "$installer"

        echo "installer has been created: '${installer}'"
    else
        echo "error: '$1' does not exist"
        exit 2
    fi
else
    help
    exit 1
fi

