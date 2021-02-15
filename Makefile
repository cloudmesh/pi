.PHONY: parts

all: parts burner

parts:
	python bin/parts.py parts/README-parts-list.yml> tmp.md 2>&1
	cms man readme -p --tag="PARTS" --file=content/en/docs/hardware/parts/parts.md --include=tmp.md
	rm -rf tmp.md

	python bin/parts-cluster.py  parts/README-parts-3.yml > tmp.md 2>&1
	cms man readme -p --tag="PARTS" --file=content/en/docs/hardware/parts/parts-3-nodes.md --include=tmp.md
	rm -rf tmp.md

	python bin/parts-cluster.py  parts/README-parts-8.yml > tmp.md 2>&1
	cms man readme -p --tag="PARTS" --file=content/en/docs/hardware/parts/parts-8-nodes.md --include=tmp.md
	rm -rf tmp.md

burner:
	cd content/en/docs/software/burner;  wget https://raw.githubusercontent.com/cloudmesh/cloudmesh-pi-burn/main/README.md
	cd content/en/docs/software/burner; tail -n +2 README.md > README-noheader.md 2>&1
	cd content/en/docs/software/burner; cat meta.md-include README-noheader.md > burner.md 2>&1
	cd content/en/docs/software/burner; rm -f README.md README-noheader.md