# DBClient
[![GitHub release](https://img.shields.io/github/v/release/lucamazzza/DBClient?color=green&label=latest%20release&sort=semver&style=for-the-badge)](https://github.com/lucamazzza/DBClient/releases/latest)
[![JDK Version](https://img.shields.io/badge/Swift-5.9.1-orange.svg?logo=swift&style=for-the-badge)](https://www.swift.org/about/)
[![License](https://img.shields.io/badge/License-MIT-purple?style=for-the-badge)](LICENSE)
[![Discord Badge](https://img.shields.io/discord/1119987238202261664?color=5865F2&label=&logo=discord&logoColor=white&style=for-the-badge)](https://discord.gg/B3yXwmHb2V)

DBClient is a `Swift` library that can be used to interact with different databases, through the language.

> ⚠️ DBClient is still in development and is not available yet! Be patient or join my [Discord Community](https://discord.gg/B3yXwmHb2V) to interact with me and contribute.

## Features

### SQL

#### MySQL


#### SQLite


#### PostgreSQL


### MongoDB


## Requirements


## Installation


## Usage


## Credits
DBClient is written and mantained by [Luca Mazza](https://mazluc.ch).

The code and the concept is inspired and "extends" [SQL-Kit](https://github.com/vapor/sql-kit) off which
I have inspired myself for the structure and some of the code.
The concept of the implementation is roughly the same, with the flavor-specific connection classes
on top. Much of the code is basically the same, just because I choose to use the same design for my library.

Be sure to also check them out to see their version of the implementation.

Also, check out the official [ISO/IEC 9075-1:2023](https://www.iso.org/standard/76583.html) standard, that defines
what is standardised for SQL database languages.

Finally, check out the official [MongoDB Reference](https://www.mongodb.com/docs/manual/reference/) on the relative
language.

## License
DBClient is released under the MIT License.
See [License](LICENSE) for details.
