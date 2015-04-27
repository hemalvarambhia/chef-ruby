ruby Cookbook
=============
Installs ruby from source. The option to install rubygems is also available
via the rubygems recipe

Requirements
------------
#### packages
- build-essentials tools required for compiling C code
- apt - update apt to get the latest package repositories
- yum-epel - update yum caches to get the latest package repositories
- yum

#### Operating systems
Ubuntu 10.04 and 12.04, CentOS 5 and 6

Attributes
----------
#### chef-ruby::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>[:ruby][:source_version]</tt></td>
    <td>String</td>
    <td>version of ruby to install</td>
    <td><tt>2.2.1</tt></td>
  </tr>
  <tr>
    <td><tt>[:ruby][:rubygems_version]</tt></td>
    <td>String</td>
    <td>version of rubygems to install</td>
    <td>1.8.24</td>
  </tr>
</table>

Usage
-----
#### ruby::default

Just include `chef-ruby` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[chef-ruby::default]"
    "recipe[chef-ruby::rubygems]"
  ]
}
```

Contributing
------------
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Hemal N. Varambhia
