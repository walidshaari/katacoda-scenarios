## Get comfertable with trivy command line options and flags


### Example image scaning use cases:

- Ignore unfixed vulnerabilities:
 
  $`trivy image --ignore-unfixed ruby:2.4.0`{{copy}}

- List by specific severities       

  $`trivy image --severity HIGH,CRITICAL ruby:2.4.0`{{copy}}

- CICD use case, ignoring vulnerability detail such as descriptions and references.Because of that, the size of the DB is smaller and the download is faster.
  
  $` trivy image --light alpine:3.10`{{copy}}

For more check out https://aquasecurity.github.io/trivy/v0.18.3/examples/



```

$trivy --help
NAME:
   trivy - A simple and comprehensive vulnerability scanner for containers

USAGE:
   trivy [global options] command [command options] target

VERSION:
   0.18.3

COMMANDS:
   image, i          scan an image
   filesystem, fs    scan local filesystem
   repository, repo  scan remote repository
   client, c         client mode
   server, s         server mode
   plugin, p         manage plugins
   help, h           Shows a list of commands or help for one command

GLOBAL OPTIONS:
   --quiet, -q        suppress progress bar and log output (default: false) [$TRIVY_QUIET]
   --debug, -d        debug mode (default: false) [$TRIVY_DEBUG]
   --cache-dir value  cache directory (default: "/home/wal/.cache/trivy") [$TRIVY_CACHE_DIR]
   --help, -h         show help (default: false)
   --version, -v      print the version (default: false)
   
```


Most likely you will use the `trivy image` commands for image scanning, get used  to the different options and how can you utilize them efficiently


```

$ trivy image --help
NAME:
   trivy image - scan an image

USAGE:
   trivy image [command options] image_name

OPTIONS:
   --template value, -t value  output template [$TRIVY_TEMPLATE]
   --format value, -f value    format (table, json, template) (default: "table") [$TRIVY_FORMAT]
   --input value, -i value     input file path instead of image name [$TRIVY_INPUT]
   --severity value, -s value  severities of vulnerabilities to be displayed (comma separated) (default: "UNKNOWN,LOW,MEDIUM,HIGH,CRITICAL") [$TRIVY_SEVERITY]
   --output value, -o value    output file name [$TRIVY_OUTPUT]
   --exit-code value           Exit code when vulnerabilities were found (default: 0) [$TRIVY_EXIT_CODE]
   --skip-update               skip db update (default: false) [$TRIVY_SKIP_UPDATE]
   --download-db-only          download/update vulnerability database but don't run a scan (default: false) [$TRIVY_DOWNLOAD_DB_ONLY]
   --reset                     remove all caches and database (default: false) [$TRIVY_RESET]
   --clear-cache, -c           clear image caches without scanning (default: false) [$TRIVY_CLEAR_CACHE]
   --no-progress               suppress progress bar (default: false) [$TRIVY_NO_PROGRESS]
   --ignore-unfixed            display only fixed vulnerabilities (default: false) [$TRIVY_IGNORE_UNFIXED]
   --removed-pkgs              detect vulnerabilities of removed packages (only for Alpine) (default: false) [$TRIVY_REMOVED_PKGS]
   --vuln-type value           comma-separated list of vulnerability types (os,library) (default: "os,library") [$TRIVY_VULN_TYPE]
   --ignorefile value          specify .trivyignore file (default: ".trivyignore") [$TRIVY_IGNOREFILE]
   --timeout value             timeout (default: 5m0s) [$TRIVY_TIMEOUT]
   --light                     light mode: it's faster, but vulnerability descriptions and references are not displayed (default: false) [$TRIVY_LIGHT]
   --ignore-policy value       specify the Rego file to evaluate each vulnerability [$TRIVY_IGNORE_POLICY]
   --list-all-pkgs             enabling the option will output all packages regardless of vulnerability (default: false) [$TRIVY_LIST_ALL_PKGS]
   --skip-files value          specify the file paths to skip traversal [$TRIVY_SKIP_FILES]
   --skip-dirs value           specify the directories where the traversal is skipped [$TRIVY_SKIP_DIRS]
   --cache-backend value       cache backend (e.g. redis://localhost:6379) (default: "fs") [$TRIVY_CACHE_BACKEND]
   --help, -h                  show help (default: false)

```
