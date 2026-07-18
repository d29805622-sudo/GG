import onnxruntime as ort


class AIEngine:

    def __init__(self):

        self.session = None

    def load(
        self,
        model_path
    ):

        providers = [
            "CUDAExecutionProvider",
            "CPUExecutionProvider"
        ]

        self.session = ort.InferenceSession(

            model_path,

            providers=providers

        )

    def run(
        self,
        input_data
    ):

        if self.session is None:

            return None

        inputs = self.session.get_inputs()

        result = self.session.run(

            None,

            {
                inputs[0].name: input_data
            }

        )

        return result
