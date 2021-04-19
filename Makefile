.PHONY: development
development: minimal requirements-dev-minimal.txt
	venv/bin/pip install -r requirements-dev-minimal.txt
	venv/bin/pre-commit install

minimal: venv/bin/activate
venv/bin/activate:
	test -d venv || python3 -m venv venv
	venv/bin/ansible-galaxy role install -r requirements-roles.yaml --roles-path vendor
	venv/bin/ansible-galaxy collection install -r requirements-collection.yaml
	touch venv/bin/activate
