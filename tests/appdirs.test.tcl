package require tcltest
namespace import tcltest::*

# Add module dir to tm paths
set ThisScriptDir [file dirname [info script]]
set ModuleDir [file normalize [file join $ThisScriptDir ..]]
::tcl::tm::path add $ModuleDir

source [file join $ThisScriptDir test_helpers.tcl]

package require appdirs

test dataHome-1 {Checks that sensible Linux dataHome directory returned} \
-setup {
  TestHelpers::setEnvironment Linux myUser
  set myAppDirs [AppDirs new myBrand myApp]
} -body {
  $myAppDirs dataHome
} -cleanup {
  TestHelpers::restoreEnvironment
} -match regexp -result "$::env(HOME).*?myApp"

test dataHome-2 {Checks that sensible Windows 2000 dataHome directory \
returned} -setup {
  TestHelpers::setEnvironment "Windows 2000" myUser
  set myAppDirs [AppDirs new myBrand myApp]
} -body {
  $myAppDirs dataHome
} -cleanup {
  TestHelpers::restoreEnvironment
} -match regexp -result {^.*?myUser.*?myBrand\\myApp$}

test dataHome-3 {Checks that sensible Windows Vista dataHome directory \
returned} -setup {
  TestHelpers::setEnvironment "Windows Vista" myUser
  set myAppDirs [AppDirs new myBrand myApp]
} -body {
  $myAppDirs dataHome
} -cleanup {
  TestHelpers::restoreEnvironment
} -match regexp -result {^.*?myUser.*?myBrand\\myApp$}

test dataHome-4 {Checks that sensible Windows Vista dataHome directory \
returned} -setup {
  TestHelpers::setEnvironment "Windows Vista" myUser
  set myAppDirs [AppDirs new myBrand myApp]
} -body {
  $myAppDirs dataHome
} -cleanup {
  TestHelpers::restoreEnvironment
} -match regexp -result {^.*?myUser.*?myBrand\\myApp$}

cleanupTests