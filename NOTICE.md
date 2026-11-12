# Notice

Edge is an independent, open-source project (AGPL-3.0, see `LICENSE`; versions up to
commit 1140dac1 were MIT, see `NOTICE`). It
is not affiliated with, sponsored by, or endorsed by WHOOP, Inc. or any of its
trademarks.

No WHOOP source code, binaries, firmware, or copyrighted assets are included
in this repository.

## WhoopsBand fork

This repository is a fork of [OpenStrap/edge](https://github.com/OpenStrap/edge)
for the WhoopsBand project. Upstream copyright remains with OpenStrap
(Copyright (c) 2026 OpenStrap). The code license remains AGPL-3.0
(see `LICENSE`). Durable attribution details are in [`ATTRIBUTION.md`](ATTRIBUTION.md).
OpenStrap name/logo use is governed by [`TRADEMARKS.md`](TRADEMARKS.md), separate
from the code license.

## wger exercise data

`lib/ui2/activity/wger_exercises.g.dart` contains selected fields (names,
aliases, muscles, equipment, categories) from the [wger](https://wger.de)
exercise database, limited to the movements listed in
`tool/wger_weightlifting_selection.dart`. Each entry is available under
CC BY-SA 3.0, CC BY-SA 4.0 or CC0, and each row keeps its source UUID and the
author/license credits of its base data and translations. This data stays under
those licenses, separate from the AGPL-licensed code. Refresh with
`dart run tool/update_wger_exercises.dart`.
