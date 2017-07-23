# DockFlow

[https://dockflow.org](https://dockflow.org)

We have accumulated numerous excellent software packages for analyzing
large-scale biomedical data on the way to delivering on the promise of
human genomics. Written as R Markdown documents,
[Bioconductor workflows](https://bioconductor.org/help/workflows/)
illustrated the feasibility of organizing and demonstrating such
software collections in a reproducible and human-readable way.

Going forward, how to implement fully automatic workflow execution
and persistently reproducible report compilation on an industrial-scale
becomes challenging from the engineering perspective. For example,
the software tools across workflows usually require drastically
different system dependencies and execution environments and thus
need to be isolated completely.

[DockFlow](https://dockflow.org/) is a proof-of-concept project exploring
the technical possibility and complexity for bioinformatics workflow
containerization and orchestration using Docker. As our first experiment,
all 18 available Bioconductor workflows were selected to be containerized.
With the help of our R package [liftr](https://liftr.me/), we show
it is possible to achieve the goal of persistent reproducible workflow
containerization by simply creating and managing a YAML configuration
file for each workflow.
