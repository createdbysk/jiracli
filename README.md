# jiracli
A cli to interact with JIRA.

# Usage
```bash
git clone ssh:git@gitlab.com:createdbysk/jiracli.git
cd jiracli
# If necessary, uncomment the line below.
# git checkout 1
make download
./bin/execute.sh https://some-jira.url my.username password $(pwd)/exampleTemplates/OpenInProgressClosed.tpl "project=SomeProject AND createdDate > -1w AND status=Closed"
```

# References
- [Build GO static libraries](https://medium.com/@diogok/on-golang-static-binaries-cross-compiling-and-plugins-1aed33499671)
- [Download gitlab artifacts](https://docs.gitlab.com/ee/ci/pipelines/job_artifacts.html)