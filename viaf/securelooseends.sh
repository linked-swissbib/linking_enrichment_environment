#!/bin/bash
#07.03.16
#benmafx

#Script to automize the secure loose ends process for viaf.

reshaperdf securelooseends viaf_enrichment.nt external_data_sorted.nt viaf_ends.nt http://schema.org/gender http://linked.swissbib.ch/vocab/schemaGenderAsLiteral




echo Done


