# BaseFEM module
-----------------
### Status:
* types: none yet
* methods: `generatetransformation` (1D,2D,3D), `localmass_P1D2`,`localstiff_P1D2`, `assembly`
* import: uses module `BaseGrid`
* export/store: none yet

### Next steps:

1. localmass_P1D(1,2,3) and localstiff_P1D(1,2,3)
2. call localmass and localstiff depending on Geometry and
   Topology to have one universal assembly loop
3. integration schemes
4. formalize treatment of Pn elements
5. discontinuous elements
6. separate computation of global matrix indices (dofhandler) from the
   computation of matrix elements -> join them in the assembly

### Open questions:
