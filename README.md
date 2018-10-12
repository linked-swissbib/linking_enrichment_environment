# Linking Workflow

This workflow connects the swissbib linked data with DBpedia & VIAF records. 


## Installation

Use the installation script in 

Use the download data script to load the data:

```
./data/download.sh
```

This will download both the DBPEDIA and VIAF data dumps. So this will take a while.

## Preparation

For the workflow to run properly the following steps have to be taken in preparation.

- Download and pre-process the DBpedia dump.
- Download and pre-process the VIAF dump.
- Download gender concepts from wikidata.

These preparatory steps have to be taken only once per dump.

Note: It might be necessary to update the links of the VIAF & DBpedia dumps.
## Run

The workflow is started with this: 
```
./run.sh
```

The workflow will import the latest swissbib data and transform it into blocks. Then it will
take the prepared blocks from the DBpedia and VIAF and compare each block to the matching
swissbib block. All the accepted triples are stored in `$LINKING_TMP_DATA_FOLDER/accepted.nt`.

## Post-processing

The post-processing takes care of merging the accepted data with the existing data and return it
as JSON-LD.
