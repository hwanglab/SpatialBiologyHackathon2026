conda env create -f scanpy_squidpy_env.yml
conda activate scanpy_env
python -m ipykernel install --user --name scanpy_env --display-name "scanpy_env (py311)"
