# robustSystem
R package with single function, *robust_system* helps you catch stdout, stderr and exit code when running external application from R.

Install with:
```{r}
library("devtools")
devtools::install_github("J-Moravec/robustSystem")
```

and use:
```{r}
library("robustSystem")
robust_system("ls")
$exit_status
[1] 0

$stderr
character(0)

$stdout
[1] "DESCRIPTION" "LICENSE"     "man"         "NAMESPACE"   "R"          
[6] "README.md" 
```

Inspired by [these](http://stackoverflow.com/questions/7014081/capture-both-exit-status-and-output-from-a-system-call-in-r) stackoverflow answers.
