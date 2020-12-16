all: sample

output:
	mkdir -p output

output/known_transitions.csv output/transitions.ev: data/american_surnames.txt
	python build_states.py

output/untrained_model.pl: model_generator.pl output/known_transitions.csv
	python ../problog-cli.py ground model_generator.pl -o $@
	sed -i '' -e 's/t("__SENTINEL__")::/t(_)::/g' $@

output/model.pl: output/untrained_model.pl output/transitions.ev output/known_transitions.csv
	python ../problog-cli.py lfi output/untrained_model.pl output/transitions.ev -O $@ --normalize --dont-propagate-evidence

query: output output/model.pl query.pl
	python ../problog-cli.py query.pl

sample: output output/model.pl query.pl
	python ../problog-cli.py sample query.pl -N 10 --with-probability

clean:
	rm -rf output
