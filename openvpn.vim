"============================================================================
"
" OpenVPN configuration syntax file
"
" Language:	   OpenVPN Configuration File
" Version:     1.09
" Date:        12-Jul-2008
" Maintainer:  Eric Haarbauer <ehaar{DOT}com{AT}grithix{DOT}dyndns{DOT}org>
" License:     This file is placed in the public domain.
"
"============================================================================
" Section:  Notes  {{{1
"============================================================================
"
" This vim syntax script highlights configuration files used with James
" Yonan's OpenVPN application (http://openvpn.net).
" 
" Features:
"
"   * Highlights options, comment lines, and arguments
"   * Recognizes quoted strings and escaped characters (e.g. \\, \")
"   * Flags arguments given for options that take no arguments
"   * Special highlighting for route and server command arguments
"
" Reporting Issues:
"
"   If you discover an OpenVPN file that this script highlights incorrectly,
"   please email the author (address at the top of the file) with the
"   following information:
"
"     * Problem OpenVPN file WITH ANY SENSITIVE INFORMATION REMOVED
"     * The release version of this script (see top of the file)
"     * If possible, a patch to fix the problem
"
" Design Notes:
"
"   Part of this script is autogenerated from the output of openvpn --help.
"   The source code for generating the script is available from the author on
"   request (see email address at the top of the script).  The script should
"   build from source on most Linux systems with openvpn installed.
"
"   The build system that generates this script strips special CVS tokens
"   (like "Id:") so that CVS no longer recognizes them.  This allows users to
"   place this script in their own version control system without losing
"   information.  The author encourages other vim script developers to adopt a
"   similar approach in their own scripts.
"
" Installation:
"
"   Put this file in your user runtime syntax directory, usually ~/.vim/syntax
"   in *NIX or C:\Program Files\vim\vimfiles\syntax in Windows.  (Type "h
"   syn-files" from within vim for more information.)
"
"   Setting up automatic filetype definition requires some knowledge about
"   your system.  The OpenVPN application itself does not require a naming
"   standard for configuration files, although most distribution packages use
"   a .conf suffix.  However, the .conf suffix is also used by many other
"   applications with different syntaxes, so one cannot determine filetype by
"   filename alone.
"
"   One way to overcome this ambiguity is to incorporate the directory name
"   into the recognition process.  For example, adding the following lines to
"   the filetype.vim file in the user runtime directory should work for many
"   *NIX systems:
"      
"       au BufNewFile,BufRead *openvpn*/*.conf setfiletype openvpn |
"                                           \  set commentstring=#%s
"
"   On the Fedora Core Linux distribution, this technique recognizes
"   configuration files in /etc/openvpn and
"   /usr/share/doc/openvpn-X.X.X/sample-config-files.  Setting the
"   commentstring option in the second line allows Meikel Brandmeyer's
"   EnhancedCommentify script (vimscript #23) to work with openvpn files.
"   (Advanced users may want to set the commentstring option in an ftplugin
"   file or in autocommands defined in .vimrc.)
"      
"   If filename- and directory-based recognition is impractical, the easiest
"   alternative is to embed the following modeline in your OpenVPN
"   configuration files:
"
"       # vim:ft=openvpn:
"
"============================================================================
" Source File: Id: openvpn.src.vim 71 2007-04-12 11:41:00Z ehaar 
"============================================================================
" Section:  Initialization  {{{1
"============================================================================

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'openvpn'
endif

" Don't use standard HiLink, it will not work with included syntax files
if version < 508
  command! -nargs=+ OpenvpnHiLink highlight link <args>
else
  command! -nargs=+ OpenvpnHiLink highlight default link <args>
endif

if version < 600
    set iskeyword+=-
else
    setlocal iskeyword+=-
endif

syntax case match

"============================================================================
" Section:  Group Definitions  {{{1
"============================================================================

syntax region openvpnNoArgLine start=" " end="$" contained transparent
    \ contains=openvpnExtraneousArg
syntax region openvpnArgLine   start=" " end="$" contained transparent
    \ contains=openvpnDevice,openvpnNumber,openvpnSpecial,openvpnQuote

syntax match  openvpnNumber "\<[.0-9]\+\>" contained
syntax match  openvpnDevice "\<\(tun\|tap\|null\)\d*\>" contained

syntax region openvpnQuote start=+"+ skip=+\\\\\\|\\"+ end=+"+
    \ contained contains=openvpnSpecial

syntax match   openvpnSpecial       +\\[ "\\]+ contained
syntax match   openvpnExtraneousArg "\S\+\p*"  contained

" The openvpn man page specifies that the comment character must be in the
" first column; however, some config files provided in the distribution have
" comment characters after options.  This file follows the spec rather than
" the examples.
syntax match   openvpnComment "^[;#].*" contains=openvpnTodo
syntax keyword openvpnTodo contained TODO FIXME XXX NOT NOTE

" IP patterns for use in special options
syntax match openvpnAddress     "\<\d\+\.\d\+\.\d\+\.\d\+\>" contained
syntax match openvpnMaskAddress "\<\d\+\.\d\+\.\d\+\.\d\+\>" contained

" route option  {{{2

syntax match openvpnOption       "^route\s\+" nextgroup=openvpnRouteNetwork

syntax match openvpnRouteNetwork "\S\+" nextgroup=openvpnRouteMask
    \ contained skipwhite contains=openvpnAddress,openvpnRouteAddress

syntax match openvpnRouteMask    "\S\+" nextgroup=openvpnRouteGateway
    \ contained skipwhite contains=openvpnMaskAddress

syntax match openvpnRouteGateway "\S\+" nextgroup=openvpnRouteMetric
    \ contained skipwhite contains=openvpnAddress,openvpnRouteAddress

syntax match openvpnRouteMetric  "\d\+" contained
    \ skipwhite nextgroup=openvpnExtraneousArg

syntax keyword openvpnRouteAddress
    \ default vpn_gateway net_gateway remote_host
    \ contained

" server option {{{2

syntax match openvpnOption "^server\s\+" nextgroup=openvpnServerNetwork

syntax match openvpnServerNetwork "\S\+" nextgroup=openvpnServerMask
    \ contained skipwhite contains=openvpnAddress

syntax match openvpnServerMask "\S\+" nextgroup=openvpnExtraneousArg
    \ contained skipwhite contains=openvpnMaskAddress

"============================================================================
" Section:  Autogenerated Groups  {{{2
"============================================================================

" Begin autogenerated section.
" openvpn:     "OpenVPN 2.1_rc8 i386-redhat-linux-gnu [SSL] [LZO2] [EPOLL] built on Jun 14 2008"
" openvpn2vim: "openvpn2vim 73 2008-07-13 02:10:18Z ehaar"

syntax keyword openvpnOption
     \ username-as-common-name up-restart up-delay tun-ipv6 tls-server 
     \ tls-exit tls-client test-crypto suppress-timestamps socks-proxy-retry 
     \ single-session show-tls show-engines show-digests show-ciphers 
     \ route-nopull route-noexec rmtun remote-random push-reset pull 
     \ ping-timer-rem persist-tun persist-remote-ip persist-local-ip 
     \ persist-key passtos nobind no-replay no-iv mute-replay-warnings 
     \ multihome mtu-test mlock mktun management-signal 
     \ management-query-passwords management-hold 
     \ management-forget-disconnect management-client-pf 
     \ management-client-auth management-client ifconfig-pool-linear 
     \ ifconfig-nowarn ifconfig-noexec http-proxy-retry genkey float fast-io 
     \ duplicate-cn down-pre disable-occ disable comp-noadapt comp-lzo 
     \ client-to-client client-cert-not-required client ccd-exclusive bind 
     \ auto-proxy auth-nocache
     \ nextgroup=openvpnNoArgLine

syntax keyword openvpnOption
     \ writepid verb user up txqueuelen tun-mtu-extra tun-mtu tran-window 
     \ topology tmp-dir tls-verify tls-timeout tls-remote tls-cipher tls-auth 
     \ tcp-queue-limit syslog status-version status socks-proxy sndbuf shaper 
     \ setenv server-bridge secret rport route-up route-metric route-gateway 
     \ route-delay resolv-retry replay-window replay-persist reneg-sec 
     \ reneg-pkts reneg-bytes remote-cert-tls remote-cert-ku remote-cert-eku 
     \ remote remap-usr1 redirect-gateway rcvbuf push proto port-share port 
     \ plugin pkcs12 ping-restart ping-exit ping ns-cert-type nice mute 
     \ mtu-disc mssfix mode max-routes-per-client max-clients 
     \ management-log-cache management lport log-append log local lladdr 
     \ link-mtu learn-address keysize key-method key keepalive iroute iproute 
     \ ipchange inetd inactive ifconfig-push ifconfig-pool-persist 
     \ ifconfig-pool ifconfig http-proxy-timeout http-proxy-option http-proxy 
     \ hash-size hand-window group gremlin fragment explicit-exit-notify 
     \ engine echo down dh dev-type dev-node dev daemon crl-verify 
     \ connect-timeout connect-retry-max connect-retry connect-freq 
     \ client-disconnect client-connect client-config-dir cipher chroot cert 
     \ cd capath ca bcast-buffers auth-user-pass-verify auth-user-pass 
     \ auth-retry auth askpass
     \ nextgroup=openvpnArgLine

" End autogenerated section.

"============================================================================
" Section:  Group Linking  {{{1
"============================================================================

OpenvpnHiLink openvpnOption        Keyword
OpenvpnHiLink openvpnComment       Comment
OpenvpnHiLink openvpnQuote         String

OpenvpnHiLink openvpnDevice        Identifier
OpenvpnHiLink openvpnNumber        Number

OpenvpnHiLink openvpnAddress       Constant
OpenvpnHiLink openvpnMaskAddress   Special

OpenvpnHiLink openvpnRouteAddress  Identifier
OpenvpnHiLink openvpnRouteMetric   Number

OpenvpnHiLink openvpnSpecial       Special
OpenvpnHiLink openvpnExtraneousArg Error
OpenvpnHiLink openvpnTodo          Todo   

"============================================================================
" Section:  Clean Up    {{{1
"============================================================================

delcommand OpenvpnHiLink

let b:current_syntax = "openvpn"

if main_syntax == 'openvpn'
  unlet main_syntax
endif

" Autoconfigure vim indentation settings
" vim:ts=4:sw=4:sts=4:fdm=marker:iskeyword+=-
