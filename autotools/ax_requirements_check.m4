AC_DEFUN([AX_REQUIREMENTS_CHECK],[

  ads_PERL_MODULE([Class::Accessor::Fast], [], [])
  ads_PERL_MODULE([JSON::PP], [], [])
  ads_PERL_MODULE([List::Util], [], [1.56])
  ads_PERL_MODULE([Log::Log4perl], [], [])
  ads_PERL_MODULE([Log::Log4perl::Level], [], [])
  ads_PERL_MODULE([Readonly], [], [])
])
