#!/usr/bin/env bash

for i in {1..4}
do
    genedrop amish_gdrop_final.par ped amish_simulation_ped$i.ped seed marker.seed oped amish_simulation_ped$i.oped
    plink --ped amish_simulation_ped$i.oped --map amish_simulation_ped.omap --no-fid --make-bed --out Amish_ped$i --noweb
    cp Amish_ped$i.fam Amish_ped$i.archive.fam
    awk -v ped=$i '{print ped, $2, $3, $4, $5, $6}' Amish_ped$i.archive.fam >Amish_ped$i.fam
    plink --bfile Amish_ped$i --extract Amish_chr22_illuminaOE.bim --make-bed --out Amish_ped${i}_illuminaOE --noweb
    plink --bfile Amish_ped${i}_illuminaOE --filter-nonfounders --make-bed --out Amish_ped${i}_illuminaOE_nonfounders --noweb
    plink --bfile Amish_ped$i --filter-founders --make-bed --out Amish_ped${i}_founders --noweb
    plink --bfile Amish_ped${i}_founders --bmerge Amish_ped${i}_illuminaOE_nonfounders.bed Amish_ped${i}_illuminaOE_nonfounders.bim Amish_ped${i}_illuminaOE_nonfounders.fam --make-bed --out Amish_ped${i}_final --noweb
done
