# Cross-platform handling of application directories
#
# Copyright (C) 2013 Lawrence Woodman <lwoodman@vlifesystems.com>
#
# Licensed under an MIT licence.  Please see LICENCE.md for details.
#
# Access the most suitable directories for an application on whatever
# platform the application is running.
#
package require Tcl 8.5
package require TclOO
package require xdgbasedir

::oo::class create AppDirs {
  variable appName brandName

  constructor {_brandName _appName} {
    set appName $_appName
    set brandName $_brandName
  }

  # Return location of user-specific data files
  method dataHome {} {
    if {$::tcl_platform(platform) eq "unix"} {
      if {$::tcl_platform(os) eq "Darwin"} {
        return [file join $::env(HOME) Library {Application Support} $brandName $appName]
      } else {
        return [XDG::DATA_HOME $appName]
      }
    } elseif {$::tcl_platform(platform) eq "windows"} {
      return [file join $::env(APPDATA) $brandName $appName]
    }
    return ""
  }

  # Return location of user-specific configuration files
  method configHome {} {
    if {$::tcl_platform(platform) eq "unix"} {
      if {$::tcl_platform(os) eq "Darwin"} {
        return [file join $::env(HOME) Library {Application Support} $brandName $appName]
      } else {
        return [XDG::CONFIG_HOME $appName]
      }
    } elseif {$::tcl_platform(platform) eq "windows"} {
      return [file join $::env(APPDATA) $brandName $appName]
    }
    return ""
  }

  # Return a list of locations for system-wide configuration files in
  # preference order
  method configDirs {} {
    if {$::tcl_platform(platform) eq "unix"} {
      if {$::tcl_platform(os) eq "Darwin"} {
        return [list [file join / Library {Application Support} $brandName \
                                $appName]]
      } else {
        return [XDG::CONFIG_DIRS $appName]
      }
    } elseif {$::tcl_platform(platform) eq "windows"} {
      set configDir [my WindowsConfigDataDir]
      if {[llength $configDir] != 0} {
        return [list $configDir]
      }
    }
    return ""
  }

  # Return a list of locations for system-wide data files in preference order
  method dataDirs {} {
    if {$::tcl_platform(platform) eq "unix"} {
      if {$::tcl_platform(os) eq "Darwin"} {
        return [list [file join / Library {Application Support} $brandName \
                                $appName]]
      } else {
        return [XDG::DATA_DIRS $appName]
      }
    } elseif {$::tcl_platform(platform) eq "windows"} {
      set configDir [my WindowsConfigDataDir]
      if {[llength $configDir] != 0} {
        return [list $configDir]
      }
    }
    return ""
  }

  method WindowsConfigDataDir {} {
    if {[info exists ::env(PROGRAMDATA)]} {
      return [file join $::env(PROGRAMDATA) $brandName $appName]
    } elseif {[info exists ::env(ALLUSERSPROFILE)]} {
      return [file join $::env(ALLUSERSPROFILE) $brandName $appName]
    }
    return ""
  }
}
