# REPRODUCE — running the MATSim-UAM incremental land-use simulations

This repo holds the **Java simulation engine + run scripts**. The scenario **data**
and **results** are deliberately NOT in git (too large — see `.gitignore`). This file
is the end-to-end recipe to rebuild and run on a fresh machine.

## Architecture (two repos + external data)

| Piece | Where | In git? |
|-------|-------|---------|
| Java engine (MATSim-UAM v3.0.0) + run scripts | **this repo** `MATSim-UAM_incremental_landuse` | yes |
| Python post-processing / accessibility / equity | `github.com/shahriarzame/matsim-uam-thesis-analysis` | yes |
| `input/basic/` (~7.2 GB) — real scenario inputs (trips, vertiport candidates, network, configs) — **required to run** | DSS only | **no** (rsync) |
| `input/FINAL/` (~767 GB) — outputs + per-experiment batch scripts — regenerable | DSS only | **no** |

Canonical data location on LRZ/DSS:
```
/dss/dssfs02/lwp-dss-0001/pr74mo/pr74mo-dss-0000/master-thesis-projects/Shahriar/MATSim-UAM/input
```

## Prerequisites
- **Java 11** (`module load openjdk/11` on LRZ) — build target is 11.
- **Maven** — the build pulls dependencies including the ETH-IVT UAM packagecloud repo (already configured in `pom.xml`).
- For cluster runs: **SLURM** (scripts target the LRZ CoolMUC `inter` clusters).

## 1. Clone
```bash
git clone https://github.com/shahriarzame/MATSim-UAM_incremental_landuse.git
cd MATSim-UAM_incremental_landuse
```

## 2. Build the jar
The fat jar `matsim-uam-3.0.0-jar-with-dependencies.jar` is **gitignored** — you must build it (or copy it):
```bash
module load openjdk/11        # or otherwise put Java 11 on PATH
mvn clean package             # -> target/ and matsim-uam-3.0.0-jar-with-dependencies.jar
```
If Maven can't reach packagecloud (offline), instead copy the prebuilt jar from the DSS project dir above.

## 3. Get the input data (~7.2 GB, not in git)
```bash
rsync -avP <dss-login-host>:/dss/dssfs02/lwp-dss-0001/pr74mo/pr74mo-dss-0000/master-thesis-projects/Shahriar/MATSim-UAM/input/basic  ./input/
```
Note: SSH port 22 is blocked *from* the cluster — initiate this **from the target machine** (pull), or use a DSS data-transfer node.

## 4. Run
General invocation used by every run script:
```bash
java -Djava.awt.headless=true -Xmx<HEAP> \
     -cp matsim-uam-3.0.0-jar-with-dependencies.jar \
     --add-opens java.base/java.lang=ALL-UNNAMED \
     <MAIN_CLASS> <args...>
```
Main classes used in this project:
- `net.bhl.matsim.uam.run.RunUAMScenario` — base UAM MATSim run (the `pom.xml` default main class).
- `net.bhl.matsim.uam.optimization.VertiportOptimizerGreedyForwardsUpdateNew` — greedy vertiport siting (see `SampleSize300.sh`).
- `net.bhl.matsim.uam.optimization.SimulatedAnnealingForPartD` — simulated-annealing siting (see `run_inter.sh`).

Example (from `run_inter.sh`):
```bash
java -Djava.awt.headless=true -Xmx60G -cp matsim-uam-3.0.0-jar-with-dependencies.jar \
  --add-opens java.base/java.lang=ALL-UNNAMED \
  net.bhl.matsim.uam.optimization.SimulatedAnnealingForPartD \
  input/scenarios/Test_1/input/optimization_trips_input_1pct.csv \
  input/basic/config_munich.xml input/basic/vertiport_candidates.csv \
  input/basic/scenario_configuration.xml
```

On SLURM, submit the provided scripts:
```bash
sbatch run_inter.sh          # small SA test — cm2_inter, Xmx60G
sbatch SampleSize300.sh      # 10-seed greedy — cm4_inter_large_mem, Xmx999G, 56 cpus
```
Adjust `--partition`, `--time`, `--mail-user`, and `-Xmx` to your machine. Off-cluster,
drop the `#SBATCH` header and set a heap your RAM supports.

## 5. Per-experiment batch scripts (the source of truth for published results)
The exact per-experiment scripts (sensitivity analysis, multi-phase, varying vertiports, …)
are auto-generated and live **inside the results tree on DSS**, e.g.:
```
input/FINAL/<experiment>/.../generated_MAIN_*.sh
input/FINAL/sensitivity_analysis/{cc_targetVnum,emission_contrGamma,rot_lures}.sh
```
They are not in git. To re-run a specific published experiment, rsync its `generated_MAIN_*.sh`
plus the inputs it references and submit it.

## 6. Analysis
```bash
git clone https://github.com/shahriarzame/matsim-uam-thesis-analysis.git
cd matsim-uam-thesis-analysis
conda env create -f environment.yml     # environment.yml is at that repo's root
```
`Python_Local_Codes/` = local (Windows-path) QGIS preprocessing; `Python_Analysis_Codes/` = cluster/result analysis.

---
Upstream is MATSim-UAM (`tum-tse`); this fork's branch `master_uam-siting_land-use` (and the exact
commit that generated the results) is preserved **only** in this private repo.
