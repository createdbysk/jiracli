# jiracli
A cli to interact with JIRA.

## Decisions
### Use spf13/cobra
* Actively maintained.
* Active community.
* Used by popular software written in go like docker/docker and kubernetes
* Briefly considered urfave/cli. [This post](https://blog.gopheracademy.com/advent-2014/introducing-cobra/), which included praise from the Jeremy Sanz, author of urfave/cli, changed my mind.

## References
* [Cobra Documentation](https://github.com/spf13/cobra)
* [Read from Stdout](https://stackoverflow.com/questions/51183462/how-to-copy-os-stdout-output-to-string-variable)