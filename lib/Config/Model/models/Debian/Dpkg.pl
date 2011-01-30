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
            'name' => 'Debian::Dpkg',
            'element' => [
                           'control',
                           {
                             'type' => 'node',
                             'description' => 'Package control file. Specifies the most vital (and version-independent) information about the source package and about the binary packages it creates.',
                             'config_class_name' => 'Debian::Dpkg::Control'
                           },
                           'copyright',
                           {
                             'summary' => 'copyright and license information',
                             'type' => 'node',
                             'description' => 'copyrigth and license information of all files containted in this packge',
                             'config_class_name' => 'Debian::Dpkg::Copyright'
                           },
                           'source',
                           {
                             'type' => 'node',
                             'config_class_name' => 'Debian::Dpkg::Source'
                           }
                         ]
          }
        ]
;
