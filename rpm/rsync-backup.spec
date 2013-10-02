%define name rsync_backup
%define version 1.0
%define unmangled_version 1.0
%define release jrc.1

Summary: Rsync Backup
Name: %{name}
Version: %{version}
Release: %{release}
Source0: %{name}-%{unmangled_version}.tar.gz
License: WTFPL
Group: Applications/Internet
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot
BuildArch: noarch
Vendor: Enrico Rossi <e.rossi@tecnobrain.com>
Packager: Enrico Rossi <enrico.rossi@ext.ec.europa.eu>
Requires: rsync bash
Url: http://enricorossi.org/gitweb/rsync_backup.git

%description
This is Yet Another RSync bAckup (yarsa).

%prep
%setup -n %{name}

%build

%define docdir %{buildroot}/usr/share/doc/%{name}

%install
mkdir -p %{buildroot}%{_bindir}
mkdir -p %{docdir}
mkdir -p %{buildroot}%{_mandir}/man1

install -m 755 rsync_backup %{buildroot}%{_bindir}
install -m 644 cron_rsync_backup.sh %{docdir}
mv doc/manpage.1 doc/rsync_backup.1
gzip doc/rsync_backup.1
install -m 644 doc/rsync_backup.1.gz %{buildroot}%{_mandir}/man1

%clean
rm -rf $RPM_BUILD_ROOT

# Specify all the files and directories by hand.
# %files -f INSTALLED_FILES
%files
%defattr(-,root,root)
%doc README COPYING
%{_bindir}/*
%{_docdir}/*
%{_mandir}/man1/*

%changelog
* Wed Oct  2 2013 Enrico Rossi <enrico.rossi@ext.ec.europa.eu> 1.0-jrc.1
- Start RPM packaging.
