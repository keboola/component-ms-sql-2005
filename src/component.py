"""
Template Component main class.

"""
import logging

import pymssql
# configuration variables
from keboola.component.base import ComponentBase
from keboola.component.exceptions import UserException

# list of mandatory parameters => if some is missing,
# component will fail with readable message on initialization.
REQUIRED_PARAMETERS = []
REQUIRED_IMAGE_PARS = []


class Component(ComponentBase):
    """
        Extends base class for general Python components. Initializes the CommonInterface
        and performs configuration validation.

        For easier debugging the data folder is picked up by default from `../data` path,
        relative to working directory.

        If `debug` parameter is present in the `config.json`, the default logger is set to verbose DEBUG mode.
    """

    def __init__(self):
        super().__init__()

    def run(self):
        """
        Main execution code
        """
        conn = pymssql.connect(server='bW9uc29vbgo.vpn2keboola.com',
                               user=self.configuration.parameters['db']['user'],
                               password=self.configuration.parameters['db']['#password'],
                               database=self.configuration.parameters['db']['database'])
        cursor = conn.cursor(as_dict=True)

        cursor.execute('SELECT 1')
        for row in cursor:
            logging.info(row)

        conn.close()


"""
        Main entrypoint
"""
if __name__ == "__main__":
    try:
        comp = Component()
        # this triggers the run method by default and is controlled by the configuration.action parameter
        comp.execute_action()
    except UserException as exc:
        logging.exception(exc)
        exit(1)
    except Exception as exc:
        logging.exception(exc)
        exit(2)
