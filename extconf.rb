#!/usr/bin/env ruby
# ruby extconf.rb --with-opt-dir=e:/Firebird

require 'mkmf'

libs = %w/ gdslib gds /  # InterBase library

# ���: InterBase ��Ƴ�������� Firebird ��Ƴ�������Ȥ��Ǥ�
# libgds.so ��¸�ߤ��뤫�⤷��ޤ���
# �㤨�� rpm -U FirebirdSS-1.5.1.4481-0.i686.nptl.rpm �����
#   /usr/lib/libgds.so -> /opt/firebird/lib/libfbclient.so
#   /usr/lib/libgds.so.0 -> /opt/firebird/lib/libfbclient.so
# ������ޤ���

fbclientlib =  # Firebird library
  case RUBY_PLATFORM
  when /bccwin32/
    "fbclient_bor"
  when /mswin32/
    "fbclient_ms"
  else
    "fbclient"
  end
libs.push fbclientlib

test_func = "isc_attach_database"

# for ruby-1.8.1 mkmf
case RUBY_PLATFORM
when /win/
  # win32(VC++6) �Ǥ� header ����ꤷ�ʤ��ȼ��Ԥ��ޤ���
  # �ޤ���ruby-1.8.1 mkmf �ϡ�have_library �� headers ���Ϥ��ޤ���
  libs.find {|lib| have_library(lib) } and
    have_func(test_func, ["ibase.h"])
else
  libs.find {|lib| have_library(lib, test_func) }
end and

create_makefile("fb")
