# 
# This file is part of Config-Model
# 
# This software is Copyright (c) 2010 by Dominique Dumont, Krzysztof Tyszecki.
# 
# This is free software, licensed under:
# 
#   The GNU Lesser General Public License, Version 2.1, February 1999
# 
[
          {
            'name' => 'Fstab::Iso9660_Opt',
            'include' => [
                           'Fstab::CommonOptions'
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