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
            'name' => 'Debian::Dep5::Content',
            'element' => [
                           'Copyright',
                           {
                             'value_type' => 'string',
                             'mandatory' => '1',
                             'type' => 'leaf',
                             'description' => 'One or more free-form copyright statement(s) that apply to the files matched by the above pattern. If a work has no copyright holder (i.e., it is in the public
        domain), that information should be recorded here.
'
                           },
                           'License',
                           {
                             'type' => 'node',
                             'config_class_name' => 'Debian::Dep5::License'
                           }
                         ]
          }
        ]
;
