import sys, os
import click

from comet_ml import ExistingExperiment
import comet_ml

@click.command()
@click.argument('experiment_dir', type=click.Path(exists=True))
def cli(experiment_dir):

    comet_config_filepath = os.path.abspath(os.path.join(experiment_dir,".comet.config"))

    if not os.path.exists(comet_config_filepath):
        print("Comet config file does not exists: {}".format(comet_config_filepath))
        sys.exit(os.EX_CONFIG) 
        
    
    comet_config = {}
    # parse .comet.config
    with open( comet_config_filepath, mode="r" ) as comet_file:
        for line in comet_file:
            name, var = line.partition("=")[::2]
            comet_config[name.strip()] = var.strip()

    # connect to comet.ml
    exp = ExistingExperiment( \
            api_key=comet_config["api_key"],\
            previous_experiment=comet_config["experiment_key"])

    # derive experiment name from exp_dir
    exp_name = os.path.basename(experiment_dir)
    exp.set_name(exp_name)

if __name__ == '__main__':
    cli()
