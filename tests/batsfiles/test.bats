#!/usr/bin/env bats

load 'test_helper/bats-support/load'
load 'test_helper/bats-assert/load'

@test "can connect to server" {
        i=0
        while ! nc -z web 80
        do
                echo Failed to connect
                ((i=$i+1))
                if [[ "$i" -gt 5 ]]; then
                        fail Timeout
                fi
                echo sleeping
                sleep 2
        done
        true
}

@test "m0pll.co.uk redirect to plett.uk" {
        run curl -o /dev/null -v --silent http://m0pll.co.uk
        assert_line -e "^< HTTP/1.1 301 .*$"
        assert_line -e "^< [Ll]ocation: https://plett\.uk/\r$"
}

@test "www.m0pll.co.uk redirect to plett.uk" {
        run curl -o /dev/null -v --silent http://www.m0pll.co.uk
        assert_line -e "^< HTTP/1.1 301 .*$"
        assert_line -e "^< [Ll]ocation: https://plett\.uk/\r$"
}

@test "web 404" {
        run curl -o /dev/null -v --silent http://web
        assert_line -e "^< HTTP/1.1 404 .*$"
}

@test "ip.plett.net" {
        run curl --silent ip.plett.net -H "Fly-Client-IP: 1.2.3.4"
        assert_line -e "^1.2.3.4$"
}

@test "ipv4.plett.net" {
        run curl --silent ipv4.plett.net -H "Fly-Client-IP: 1.2.3.4"
        assert_line -e "^1.2.3.4$"
}

@test "ipv6.plett.net" {
        run curl --silent ipv6.plett.net -H "Fly-Client-IP: 1.2.3.4"
        assert_line -e "^1.2.3.4$"
}

@test "ip.plett.net/robots.txt" {
        run curl -o /dev/null -v --silent http://ip.plett.net/robots.txt
        assert_line -e "^< HTTP/1.1 200 .*$"
}

@test "ip.plett.net 404" {
        run curl -o /dev/null -v --silent http://ip.plett.net/nosuchfile.txt
        assert_line -e "^< HTTP/1.1 404 .*$"
}

@test "bold-silence-8386.fly.dev redirect to github" {
        run curl -o /dev/null -v --silent http://bold-silence-8386.fly.dev
        assert_line -e "^< HTTP/1.1 301 .*$"
        assert_line -e "^< [Ll]ocation: https://github\.com/plett/fly\.io-nginx-redir\r$"
}
