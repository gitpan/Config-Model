#
# This file is part of Config-Model
#
# This software is Copyright (c) 2015 by Dominique Dumont.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
[
          {
            'name' => 'MyFstab::Iso9660_Opt',
            'include' => [
                           'MyFstab::CommonOptions'
                         ],
            'element' => [
                           'rock',
                           {
                             'value_type' => 'boolean',
                             'type' => 'leaf'
                           },
                           'joliet',
                           {
                             'value_type' => 'boolean',
                             'type' => 'leaf'
                           }
                         ]
          }
        ]
;
