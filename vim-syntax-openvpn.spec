%define		_vimdatadir	%{_datadir}/vim/vimfiles
%define		syntax		openvpn
Summary:	Vim syntax: Highlight code in OpenVPN config file
Summary(pl.UTF-8):	Opis składni dla Vima: podświetlanie kodu wewnątrz plików konfiguracyjnych OpenVPN
Name:		vim-syntax-openvpn
Version:	1.09
Release:	1
License:	public domain
Group:		Applications/Editors/Vim
#Source0:	http://vim.sourceforge.net/scripts/download_script.php?src_id=8938
Source0:	%{syntax}.vim
URL:		http://vim.sourceforge.net/scripts/script.php?script_id=1420
# for _vimdatadir existence
Requires:	vim >= 4:6.3.058-3
BuildArch:	noarch
BuildRoot:	%{tmpdir}/%{name}-%{version}-root-%(id -u -n)

%description
This script highlights code in OpenVPN config file.

%description -l pl.UTF-8
Ten skrypt podświetla kod w pliku konfiguracyjnym OpenVPN.

%prep

%install
rm -rf $RPM_BUILD_ROOT

install -d $RPM_BUILD_ROOT%{_vimdatadir}/{syntax,ftdetect}
install %{SOURCE0} $RPM_BUILD_ROOT%{_vimdatadir}/syntax/%{syntax}.vim

cat > $RPM_BUILD_ROOT%{_vimdatadir}/ftdetect/%{syntax}.vim <<EOF
au BufNewFile,BufRead *openvpn*/*.conf set filetype=%{syntax}
EOF

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(644,root,root,755)
%{_vimdatadir}/syntax/*
%{_vimdatadir}/ftdetect/*
