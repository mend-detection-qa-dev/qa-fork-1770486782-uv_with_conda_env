# Phase 4 Combined Integration Test: UV with Conda Environment

## Test ID
T-P4-008

## Category
Combined Integration - UV Package Management with Conda Environment

## Priority
P1

## Description
This fixture demonstrates using UV for fast package management while leveraging Conda for environment management. This is a real-world pattern in data science where Conda creates the virtual environment (especially for system-level dependencies), but UV manages Python packages for better performance.

## Use Case
**Scenario:** Data science teams want:
- Conda for environment isolation and system dependencies (CUDA, MKL, etc.)
- UV for fast Python package installation and management
- Best of both worlds: Conda's ecosystem + UV's speed

## Features Combined
1. **Conda Environment** - environment.yml defines environment with Python version
2. **UV Package Management** - pyproject.toml + uv.lock for Python packages
3. **No Conda Packages** - Conda only creates venv, doesn't manage Python packages
4. **UV Sync to Conda Venv** - UV installs packages into Conda-created environment
5. **System Dependencies** - Conda handles system-level requirements

## Real-World Inspiration
Based on patterns from:
- Data science teams using Conda + UV hybrid approach
- Projects requiring CUDA/MKL but wanting fast Python package management
- Teams migrating from Conda to UV incrementally
- Enterprise environments with Conda infrastructure

## Workflow

### Step 1: Conda Creates Environment
```bash
# Create Conda environment with Python and system dependencies
conda env create -f environment.yml

# Activate the environment
conda activate uv-conda-project
```

**What Conda Provides:**
- Python interpreter (specific version)
- Virtual environment isolation
- System-level dependencies (if any)
- **NOT managing Python packages**

### Step 2: UV Manages Python Packages
```bash
# UV installs packages into the activated Conda environment
uv sync

# UV uses the Python from Conda environment
# UV creates uv.lock for reproducible installs
# UV installs all packages defined in pyproject.toml
```

**What UV Provides:**
- Fast package resolution and installation
- Lock file for reproducibility (uv.lock)
- Dependency tree management
- Package version pinning

## File Structure

```
uv_with_conda_env/
├── environment.yml          # Conda environment specification
├── pyproject.toml          # UV/PEP 621 Python package dependencies
├── uv.lock                 # UV lock file
├── README.md               # This file
└── .condarc (optional)     # Conda configuration
```

## Test Objectives
1. Verify Conda environment creation with environment.yml
2. Verify UV can sync packages to Conda-created environment
3. Verify UV respects Conda's Python version
4. Verify lock file generation in Conda environment
5. Verify no conflict between Conda and UV
6. Verify UV doesn't try to manage Conda packages

## Success Criteria
- [ ] Conda environment creates successfully from environment.yml
- [ ] UV detects and uses Conda Python interpreter
- [ ] UV sync installs packages into Conda environment
- [ ] uv.lock generated correctly
- [ ] No package manager conflicts
- [ ] Python packages managed by UV, not Conda
- [ ] Environment reproducible on other machines
- [ ] Clear documentation of hybrid workflow

## Environment Setup

### Prerequisites
- Conda (Miniconda or Anaconda) installed
- UV installed
- Both in PATH

### Commands
```bash
# 1. Create Conda environment
conda env create -f environment.yml

# 2. Activate environment
conda activate uv-conda-project

# 3. Verify Python from Conda
which python
# Should show: ~/miniconda3/envs/uv-conda-project/bin/python

# 4. UV sync packages
uv sync

# 5. Verify packages installed
pip list

# 6. Run application
python -c "import numpy, pandas, requests; print('All packages loaded')"
```

## Integration Points

### Conda Responsibilities
- ✅ Create virtual environment
- ✅ Install Python interpreter
- ✅ Provide system-level dependencies (CUDA, MKL, etc.)
- ✅ Environment isolation
- ❌ **NOT** managing Python packages

### UV Responsibilities
- ✅ Resolve Python package dependencies
- ✅ Generate lock file (uv.lock)
- ✅ Install Python packages
- ✅ Fast package management
- ❌ **NOT** creating virtual environment

## Testing Scenarios

### Scenario 1: Fresh Setup
```bash
# Clone project
git clone <repo>
cd uv_with_conda_env

# Create Conda env
conda env create -f environment.yml
conda activate uv-conda-project

# Install packages with UV
uv sync

# Test
python -c "import requests; print(requests.__version__)"
```

### Scenario 2: Update Dependencies
```bash
# Add new package to pyproject.toml
# dependencies = [..., "new-package>=1.0.0"]

# Update lock file
uv lock

# Sync new packages
uv sync
```

### Scenario 3: CI/CD Pipeline
```yaml
# .github/workflows/test.yml
steps:
  - name: Setup Conda
    uses: conda-incubator/setup-miniconda@v2
    with:
      environment-file: environment.yml

  - name: Install UV
    run: pip install uv

  - name: Install dependencies
    run: uv sync

  - name: Run tests
    run: pytest
```

## Advantages of This Approach

### Why Conda for Environment?
- System-level dependencies (CUDA, MKL, compilers)
- Cross-platform environment specification
- Proven in data science/ML workflows
- Binary package distribution for complex deps

### Why UV for Packages?
- 10-100x faster than pip/conda for Python packages
- Better dependency resolution
- Lock file for reproducibility
- Simpler pyproject.toml vs complex environment.yml

### Combined Benefits
- Fast package management (UV)
- Robust environment management (Conda)
- No conflict between tools
- Each tool does what it's best at

## UV Version Compatibility
- Minimum: UV 0.4.0+
- Recommended: UV 0.7.0+

## Conda Version Compatibility
- Minimum: Conda 4.x+
- Works with: Miniconda, Anaconda, Mamba

## Files in this Fixture
- `environment.yml` - Conda environment specification
- `pyproject.toml` - UV package dependencies
- `uv.lock` - UV lock file (generated)
- `README.md` - This file
- `setup_env.sh` - Helper script for setup

## Mend Integration Notes
This fixture tests Mend's ability to:
- Scan projects using Conda + UV hybrid
- Detect both environment.yml and pyproject.toml
- Identify which packages from which source
- Handle Conda environments in scanning
- Report vulnerabilities correctly

**Mend Configuration:**
```properties
# Mend should scan UV packages
python.resolveDependencies=true
python.packageManager=uv

# Conda environment.yml for context
# (Mend may note system dependencies)
```

## Related Tests
- T-P2-009: Platform Markers (related system dependencies)
- T-P4-003: Data Science Platform
- T-P1-001: Basic Dependency Tree Resolution

## Common Issues & Solutions

### Issue 1: UV Not Finding Conda Python
**Problem:** UV uses system Python instead of Conda Python
**Solution:**
```bash
# Ensure Conda environment is activated
conda activate uv-conda-project

# Verify Python
which python

# UV should auto-detect
uv sync
```

### Issue 2: Package Conflicts
**Problem:** Same package in both Conda and UV
**Solution:**
- Only specify Python and system deps in environment.yml
- All Python packages in pyproject.toml
- Let UV manage all Python packages

### Issue 3: Lock File Differences
**Problem:** Lock file differs across platforms
**Solution:**
- Commit uv.lock to repo
- Platform-specific deps in pyproject.toml markers
- Regenerate if needed

## Best Practices

### DO:
✅ Use Conda for: Python version, system dependencies
✅ Use UV for: All Python packages
✅ Activate Conda env before UV commands
✅ Commit both environment.yml and uv.lock

### DON'T:
❌ Don't specify Python packages in environment.yml
❌ Don't use `conda install` for Python packages
❌ Don't mix package managers for same dependencies
❌ Don't forget to activate Conda environment

## Migration Path

### From Conda-Only to Conda+UV:
1. Start: Everything in environment.yml
2. Create pyproject.toml with Python packages
3. Remove Python packages from environment.yml
4. Keep only Python + system deps in environment.yml
5. Run `uv lock` to create lock file
6. Run `uv sync` to install packages
7. Test thoroughly
8. Update CI/CD workflows

## Documentation Links
- UV Documentation: https://docs.astral.sh/uv/
- Conda Documentation: https://docs.conda.io/
- PEP 621 (pyproject.toml): https://peps.python.org/pep-0621/