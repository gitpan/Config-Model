#
# This file is part of Config-Model
#
# This software is Copyright (c) 2012 by Dominique Dumont, Krzysztof Tyszecki.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
[
  {
    'class_description' => 'generated from LCDd.conf',
    'name' => 'LCDd::EyeboxOne',
    'element' => [
      'Backlight',
      {
        'value_type' => 'uniline',
        'upstream_default' => 'yes',
        'type' => 'leaf',
        'description' => 'Switch on the backlight? '
      },
      'Cursor',
      {
        'value_type' => 'uniline',
        'upstream_default' => 'no',
        'type' => 'leaf',
        'description' => 'Switch on the cursor? '
      },
      'Device',
      {
        'value_type' => 'uniline',
        'upstream_default' => '/dev/ttyS1',
        'type' => 'leaf',
        'description' => 'Select the output device to use '
      },
      'DownKey',
      {
        'value_type' => 'uniline',
        'default' => 'B',
        'type' => 'leaf'
      },
      'EscapeKey',
      {
        'value_type' => 'uniline',
        'default' => 'P',
        'type' => 'leaf'
      },
      'LeftKey',
      {
        'value_type' => 'uniline',
        'default' => 'D',
        'type' => 'leaf',
        'description' => 'Enter Key is a \\r character, so it\'s hardcoded in the driver'
      },
      'RightKey',
      {
        'value_type' => 'uniline',
        'default' => 'C',
        'type' => 'leaf'
      },
      'Size',
      {
        'value_type' => 'uniline',
        'upstream_default' => '20x4',
        'type' => 'leaf',
        'description' => 'Set the display size '
      },
      'Speed',
      {
        'value_type' => 'enum',
        'upstream_default' => '19200',
        'type' => 'leaf',
        'description' => 'Set the communication speed ',
        'choice' => [
          '1200',
          '2400',
          '9600',
          '19200'
        ]
      },
      'UpKey',
      {
        'value_type' => 'uniline',
        'default' => 'A',
        'type' => 'leaf'
      },
      'keypad_test_mode',
      {
        'value_type' => 'uniline',
        'default' => 'no',
        'type' => 'leaf',
        'description' => 'You can find out which key of your display sends which
character by setting keypad_test_mode to yes and running
LCDd. LCDd will output all characters it receives.
Afterwards you can modify the settings above and set
keypad_set_mode to no again.'
      }
    ]
  }
]
;

