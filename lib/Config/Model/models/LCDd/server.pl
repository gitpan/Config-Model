#
# This file is part of Config-Model
#
# This software is Copyright (c) 2011 by Dominique Dumont, Krzysztof Tyszecki.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
[
  {
    'name' => 'LCDd::server',
    'element' => [
      'DriverPath',
      {
        'value_type' => 'uniline',
        'match' => '/$',
        'default' => '/usr/lib/lcdproc/',
        'type' => 'leaf',
        'description' => 'Where can we find the driver modules ?
IMPORTANT: Make sure to change this setting to reflect your
           specific setup! Otherwise LCDd won\'t be able to find
           the driver modules and will thus not be able to
           function properly.
NOTE: Always place a slash as last character !
[ match:"\\/$" assert:"-d" ]'
      },
      'Driver',
      {
        'value_type' => 'enum',
        'type' => 'leaf',
        'description' => 'Tells the server to load the given drivers. Multiple lines can be given.
The name of the driver is case sensitive and determines the section
where to look for further configuration options of the specific driver
as well as the name of the dynamic driver module to load at runtime.
The latter one can be changed by giving af File= directive in the
driver specific section.

The following drivers are supported:
  bayrad, CFontz, CFontz633, CFontzPacket, curses, CwLnx, ea65,
  EyeboxOne, g15, glcdlib, glk, hd44780, icp_a106, imon, imonlcd,
  IOWarrior, irman, joy, lb216, lcdm001, lcterm, lirc, lis, MD8800,
  mdm166a, ms6931, mtc_s16209x, MtxOrb, mx5000, NoritakeVFD, picolcd,
  pyramid, sed1330, sed1520, serialPOS, serialVFD, shuttleVFD, sli,
  stv5730, svga, t6963, text, tyan, ula200, xosd
{ warn_if_match:"CFontz 633" 
  message="this driver is deprecated, please use CFontzPacket driver with Model=633 instead." 
  load="server Driver=CFontzPacket - CFontzPacket model=633"
}',
        'choice' => [
          'bayrad',
          'CFontz',
          'CFontz633',
          'CFontzPacket',
          'curses',
          'CwLnx',
          'ea65',
          'EyeboxOne',
          'g15',
          'glcdlib',
          'glk',
          'hd44780',
          'icp_a106',
          'imon',
          'imonlcd',
          'IOWarrior',
          'irman',
          'joy',
          'lb216',
          'lcdm001',
          'lcterm',
          'lirc',
          'lis',
          'MD8800',
          'mdm166a',
          'ms6931',
          'mtc_s16209x',
          'MtxOrb',
          'mx5000',
          'NoritakeVFD',
          'picolcd',
          'pyramid',
          'sed1330',
          'sed1520',
          'serialPOS',
          'serialVFD',
          'shuttleVFD',
          'sli',
          'stv5730',
          'svga',
          't6963',
          'text',
          'tyan',
          'ula200',
          'xosd',
          'warn_if_match',
          'CFontz',
          '633',
          'message',
          'this',
          'driver',
          'is',
          'deprecated',
          'please',
          'use',
          'CFontzPacket',
          'driver',
          'with',
          'Model',
          '633',
          'instead',
          'load',
          'server',
          'Driver',
          'CFontzPacket',
          'CFontzPacket',
          'model',
          '633'
        ]
      },
      'Bind',
      {
        'value_type' => 'uniline',
        'default' => '127.0.0.1',
        'type' => 'leaf',
        'description' => 'Tells the driver to bind to the given interface'
      },
      'Port',
      {
        'value_type' => 'integer',
        'default' => '13666',
        'type' => 'leaf',
        'description' => 'Listen on this specified port; defaults to 13666.'
      },
      'ReportLevel',
      {
        'value_type' => 'integer',
        'upstream_default' => '2',
        'type' => 'leaf',
        'description' => 'Sets the reporting level; defaults to 2 (warnings and errors only).
[ value_type: int; max: 3; default: 2; ]
{ help 0:"no report" 1:"reports errors" 2:"reports warnings" 3:"reports info" }'
      },
      'ReportToSyslog',
      {
        'value_type' => 'enum',
        'upstream_default' => 'no',
        'type' => 'leaf',
        'description' => 'Should we report to syslog instead of stderr ? [default: no; legal: yes, no]',
        'choice' => [
          'yes',
          'no'
        ]
      },
      'User',
      {
        'value_type' => 'uniline',
        'default' => 'nobody',
        'type' => 'leaf',
        'description' => 'User to run as.  LCDd will drop its root privileges, if any,
and run as this user instead.'
      },
      'Foreground',
      {
        'value_type' => 'enum',
        'default' => 'no',
        'type' => 'leaf',
        'description' => 'The server will stay in the foreground if set to true.
[ legal: yes, no ]',
        'choice' => [
          'yes',
          'no'
        ]
      },
      'Hello',
      {
        'cargo' => {
          'value_type' => 'uniline',
          'type' => 'leaf'
        },
        'default_with_init' => {
          '1' => '"    LCDproc!"',
          '0' => '"    Hello"'
        },
        'type' => 'list',
        'description' => 'Hello message: each entry represents a display line; default: builtin'
      },
      'GoodBye',
      {
        'cargo' => {
          'value_type' => 'uniline',
          'type' => 'leaf'
        },
        'default_with_init' => {
          '1' => '"    LCDproc!"',
          '0' => '"    GoodBye"'
        },
        'type' => 'list',
        'description' => 'GoodBye message: each entry represents a display line; default: builtin'
      },
      'WaitTime',
      {
        'value_type' => 'integer',
        'default' => '5',
        'type' => 'leaf',
        'description' => 'Sets the default time in seconds to displays a screen.'
      },
      'ServerScreen',
      {
        'value_type' => 'enum',
        'upstream_default' => 'on',
        'type' => 'leaf',
        'description' => 'If yes, the the serverscreen will be rotated as a usual info screen. If no,
it will be a background screen, only visible when no other screens are
active. The special value \'blank\' is similar to no, but only a blank screen
is displayed. [default: on; legal: on, off, blank]',
        'choice' => [
          'on',
          'off',
          'blank'
        ]
      },
      'Backlight',
      {
        'value_type' => 'enum',
        'upstream_default' => 'open',
        'type' => 'leaf',
        'description' => 'Set master backlight setting. If set to \'open\' a client may control the
backlight for its own screens (only). [default: open; legal: off, open, on]',
        'choice' => [
          'off',
          'open',
          'on'
        ]
      },
      'Heartbeat',
      {
        'value_type' => 'enum',
        'upstream_default' => 'open',
        'type' => 'leaf',
        'description' => 'Set master heartbeat setting. If set to \'open\' a client may control the
heartbeat for its own screens (only). [default: open; legal: off, open, on]',
        'choice' => [
          'off',
          'open',
          'on'
        ]
      },
      'TitleSpeed',
      {
        'value_type' => 'integer',
        'min' => '0',
        'upstream_default' => '10',
        'max' => '10',
        'type' => 'leaf',
        'description' => 'set title scrolling speed [default: 10; legal: 0-10]'
      },
      'ToggleRotateKey',
      {
        'value_type' => 'uniline',
        'default' => 'Enter',
        'type' => 'leaf',
        'description' => 'The "...Key=" lines define what the server does with keypresses that
don\'t go to any client.
These are the defaults:'
      },
      'PrevScreenKey',
      {
        'value_type' => 'uniline',
        'default' => 'Left',
        'type' => 'leaf'
      },
      'NextScreenKey',
      {
        'value_type' => 'uniline',
        'default' => 'Right',
        'type' => 'leaf'
      },
      'ScrollUpKey',
      {
        'value_type' => 'uniline',
        'default' => 'Up',
        'type' => 'leaf'
      },
      'ScrollDownKey',
      {
        'value_type' => 'uniline',
        'default' => 'Down',
        'type' => 'leaf'
      }
    ]
  }
]
;

