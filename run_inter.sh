#!/bin/bash
#SBATCH -o ./logfile_%x_%j_%N.log
#SBATCH -J test-1
#SBATCH --get-user-env
#SBATCH --clusters=inter
#SBATCH --partition=cm2_inter
#SBATCH --ntasks=1
#SBATCH --export=none
#SBATCH --mail-type=end
#SBATCH --mail-user=shahriar.zame@tum.de
#SBATCH --time=01:59:59
# export OMP_NUM_THREADS=7

date
hostname

classpath="matsim-uam-3.0.0-jar-with-dependencies.jar"

echo "***"
echo "classpath: $classpath"
echo "***"

# java command
java_command="java -Djava.awt.headless=true -Xmx60G -cp $classpath --add-opens java.base/java.lang=ALL-UNNAMED"

# main
main="net.bhl.matsim.uam.optimization.SimulatedAnnealingForPartD"

# arguments
arguments="input/scenarios/Test_1/input/optimization_trips_input_1pct.csv input/basic/config_munich.xml input/basic/vertiport_candidates.csv input/basic/scenario_configuration.xml"

# command
command="$java_command $main $arguments"

echo ""
echo "command is $command"

echo ""
echo "using alternative java"
module load openjdk/11
java -version

$command