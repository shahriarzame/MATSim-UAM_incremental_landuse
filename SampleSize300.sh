#!/bin/bash
#SBATCH -o ./logfile_GRDU_Sample_300.log
#SBATCH -J uam
#SBATCH --get-user-env
#SBATCH --clusters=inter
#SBATCH --partition=cm4_inter_large_mem
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=56
#SBATCH --export=none
#SBATCH --mail-type=end
#SBATCH --mail-user=tao2000.guo@tum.de
#SBATCH --time=42:59:59

module load openjdk/11
java -version
 
# export OMP_NUM_THREADS=8

date
hostname

classpath="matsim-uam-3.0.0-jar-with-dependencies.jar"

echo "***"
echo "classpath: $classpath"
echo "***"

# java command
java_command="java -Djava.awt.headless=true -Xmx999G -cp $classpath --add-opens java.base/java.lang=ALL-UNNAMED"


# commands for VertiportOptimizerGreedyForwardsUpdateNew
# main
main="net.bhl.matsim.uam.optimization.VertiportOptimizerGreedyForwardsUpdateNew"

args1="input/LongTripsWithUtilityForRunFilippos.csv input/config_munich.xml input/vertiport_with_cost.csv 300 Munich_A -151318069848506445"
args2="input/LongTripsWithUtilityForRunFilippos.csv input/config_munich.xml input/vertiport_with_cost.csv 300 Munich_A 8048258825199035766"
args3="input/LongTripsWithUtilityForRunFilippos.csv input/config_munich.xml input/vertiport_with_cost.csv 300 Munich_A 6250448518559340093"
args4="input/LongTripsWithUtilityForRunFilippos.csv input/config_munich.xml input/vertiport_with_cost.csv 300 Munich_A -9070374854913575318"
args5="input/LongTripsWithUtilityForRunFilippos.csv input/config_munich.xml input/vertiport_with_cost.csv 300 Munich_A -7204047724964596929"
args6="input/LongTripsWithUtilityForRunFilippos.csv input/config_munich.xml input/vertiport_with_cost.csv 300 Munich_A -7790633931899473891"
args7="input/LongTripsWithUtilityForRunFilippos.csv input/config_munich.xml input/vertiport_with_cost.csv 300 Munich_A 3299169240476921399"
args8="input/LongTripsWithUtilityForRunFilippos.csv input/config_munich.xml input/vertiport_with_cost.csv 300 Munich_A -3170854754595842999"
args9="input/LongTripsWithUtilityForRunFilippos.csv input/config_munich.xml input/vertiport_with_cost.csv 300 Munich_A 7860881614405995101"
args10="input/LongTripsWithUtilityForRunFilippos.csv input/config_munich.xml input/vertiport_with_cost.csv 300 Munich_A 4302261656370467045"


command1="$java_command $main $args1"
command2="$java_command $main $args2"
command3="$java_command $main $args3"
command4="$java_command $main $args4"
command5="$java_command $main $args5"
command6="$java_command $main $args6"
command7="$java_command $main $args7"
command8="$java_command $main $args8"
command9="$java_command $main $args9"
command10="$java_command $main $args10"


echo ""
echo "Run 1 Starts"
eval $command1

echo ""
echo "Run 2 Starts"
eval $command2

echo ""
echo "Run 3 Starts"
eval $command3

echo ""
echo "Run 4 Starts"
eval $command4

echo ""
echo "Run 5 Starts"
eval $command5

echo ""
echo "Run 6 Starts"
eval $command6

echo ""
echo "Run 7 Starts"
eval $command7

echo ""
echo "Run 8 Starts"
eval $command8

echo ""
echo "Run 9 Starts"
eval $command9

echo ""
echo "Run 10 Starts"
eval $command10

