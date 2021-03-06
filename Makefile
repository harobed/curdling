SHELL=bash

PACKAGE=curdling

CUSTOM_PIP_INDEX=

TESTS_VERBOSITY=2

EXTRA_TEST_TASKS=

DUMMY_PYPI_PORT=8000

PYTHON_SERVER_MODULE=`python -c 'import sys; print("SimpleHTTPServer" if tuple(sys.version_info)[0] == 2 else "http.server")'`


all: test


test: unit functional $(EXTRA_TEST_TASKS)


unit: setup
	@TZ=EST+5EDT make run_test suite=unit


functional: setup
	@make dummypypi_start
	@TZ=EST+5EDT make run_test suite=functional
	@make dummypypi_stop


dummypypi_start:
	@make dummypypi_stop
	@(cd tests/dummypypi && python -m $(PYTHON_SERVER_MODULE) >/dev/null 2>&1 &) && \
		while :; do `curl http://localhost:$(DUMMY_PYPI_PORT) > /dev/null 2>&1` && break; done


dummypypi_stop:
	-@ps aux | grep SimpleHTTPServer | grep -v grep | awk '{ print $$2 }' | xargs kill -9 2>/dev/null


setup: clean
	@if [ -z $$VIRTUAL_ENV ]; then                                       \
		echo "Cowardly refusing to run out of a virtualenv";         \
		exit 1;                                                      \
	fi
	@if [ -z $$SKIP_DEPS ]; then                                         \
		echo "Installing dependencies...";                           \
		pip install --quiet -r development.txt;                      \
	fi


run_test:
	@if [ -d tests/$(suite) ]; then                                                 \
		if [ "`ls tests/$(suite)/*.py`" = "tests/$(suite)/__init__.py" ] ; then \
			echo "No \033[0;32m$(suite)\033[0m tests...";                   \
		else                                                                    \
			printf "|\033[0;32m Running $(suite) test suite \033[0m|\n";    \
			nosetests                                                       \
                          --stop                                                        \
                          --with-coverage                                               \
			  --cover-package=$(PACKAGE)                                    \
                          --cover-branches                                              \
                          --verbosity=$(TESTS_VERBOSITY)                                \
                          -s tests/$(suite) ;                                           \
		fi                                                                      \
	fi


clean:
	@echo "Removing garbage..."
	@find . -name '*.pyc' -delete
	@rm -rf .coverage *.egg-info *.log build dist MANIFEST


deploy-docs:
	@echo "Deploying docs to GH-Pages"
	@(cd docs && make html)
	@mv docs/_build/html /tmp/curdling-documentation
	@git checkout gh-pages
	@rm -rf *
	@mv /tmp/curdling-documentation/* .
	@rm -rf /tmp/curdling-documentation
	@touch .nojekyll
	@git add --all .
	@git commit -m 'make deploy-docs at your service'
	@git push origin gh-pages
	@git checkout master


publish:
	@if [ -e "$$HOME/.pypirc" ]; then                                               \
		echo "Uploading to '$(CUSTOM_PIP_INDEX)'";                              \
		python setup.py register -r "$(CUSTOM_PIP_INDEX)";                      \
		python setup.py sdist upload -r "$(CUSTOM_PIP_INDEX)";                  \
	else                                                                            \
		echo "You should create a file called \`.pypirc' under your home dir."; \
		echo "That's the right place to configure \`pypi' repos.";              \
		exit 1;                                                                 \
	fi
