.PHONY: development
development: minimal requirements-dev-minimal.txt
	venv/bin/pip install -r requirements-dev-minimal.txt
	venv/bin/pre-commit install

.PHONY: install
install: minimal
	bin/run-playbook --host localhost

minimal: venv/bin/activate
venv/bin/activate: requirements-minimal.txt
	test -d venv || python3 -m venv venv
	venv/bin/pip install --upgrade pip
	venv/bin/pip install -r requirements-minimal.txt
	venv/bin/ansible-galaxy role install -r requirements-roles.yaml --roles-path vendor
	venv/bin/ansible-galaxy collection install -r requirements-collection.yaml
	touch venv/bin/activate
