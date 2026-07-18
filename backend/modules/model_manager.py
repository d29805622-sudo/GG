import os


class ModelManager:

    def __init__(self):

        self.models = {}

    def load_model(
        self,
        name,
        path
    ):

        if not os.path.exists(path):

            raise FileNotFoundError(
                path
            )

        self.models[name] = path

    def get_model(
        self,
        name
    ):

        return self.models.get(
            name
        )

    def list_models(self):

        return list(
            self.models.keys()
        )
