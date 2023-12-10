function pkg -a arg -d 'A alias script for pacman'
    function _run_cmd
        set_color green
        echo -e "$argv" '\n'
        set_color normal

        eval $argv

        functions --erase _run_cmd
    end

    set -l args $argv[2..]

    argparse y/yes s/sync -- $args; or return

    test $_flag_y && set -l yes --noconfirm
    test $_flag_s && set -l sync -yy

    switch $arg
        case i in install
            _run_cmd 'sudo pacman -S --needed' $yes $sync $args

        case r rm remove
            _run_cmd 'sudo pacman -Runsc' $yes $args

        case u up update
            _run_cmd 'sudo pacman -Su --needed' $yes $sync $args

        case s search
            _run_cmd 'pacman -Ss' $args

        case f fd find
            _run_cmd 'pacman -Si' $args

        case '*'
            set_color red
            echo Argument \"$arg\" 'is not recognized by pkg.'
            set_color normal
            return 1
    end
end

# completions
complete -f -c pkg -n "not __fish_seen_subcommand_from install" -a install -d 'install packages'
complete -f -c pkg -n "__fish_seen_subcommand_from i in install" -a "(__fish_print_pacman_packages)"

complete -f -c pkg -n "not __fish_seen_subcommand_from remove" -a remove -d 'remove packages'
complete -f -c pkg -n "__fish_seen_subcommand_from r rm remove" -a "(__fish_print_pacman_packages --installed)"

complete -f -c pkg -n "not __fish_seen_subcommand_from find" -a find -d 'find packages'
complete -f -c pkg -n "__fish_seen_subcommand_from f fd find" -a "(__fish_print_pacman_packages)"

complete -f -c pkg -n "not __fish_seen_subcommand_from update" -a update -d 'update packages'
complete -f -c pkg -n "__fish_seen_subcommand_from u up update" -a "(__fish_print_pacman_packages)"

complete -f -c pkg -n "not __fish_seen_subcommand_from search" -a search -d 'search packages'
complete -f -c pkg -n "__fish_seen_subcommand_from s search" -a "(__fish_print_pacman_packages)"
