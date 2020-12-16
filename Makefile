all: sample

output:
	mkdir -p output

output/known_transitions.csv: data/american_surnames.txt
output/transitions.ev: data/american_surnames.txt
	python build_states.py

output/untrained_model.pl: transition_function_template.pl output/known_transitions.csv
	python ../problog-cli.py ground transition_function_template.pl -o output/untrained_model.pl
	sed -i '' -e 's/t("__SENTINEL__")::/t(_)::/g' output/untrained_model.pl

output/model.pl: output/untrained_model.pl output/transitions.ev output/known_transitions.csv
	python ../problog-cli.py lfi output/untrained_model.pl output/transitions.ev -O output/model.pl --normalize --dont-propagate-evidence

query: output output/model.pl query.pl
	python ../problog-cli.py query.pl

sample: output/model.pl query.pl
	python ../problog-cli.py sample query.pl -N 10 --with-probability

clean:
	rm -rf output
