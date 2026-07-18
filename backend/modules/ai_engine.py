import onnxruntime as ort

from config import GPU_ENABLE


class AIEngine:

    def __init__(self):

        self.session = None

    def load(
        self,
        model_path
    ):

        # GPU_ENABLE=False 时只用 CPU，避免 CUDA provider 不可用时报错
        if GPU_ENABLE:
            providers = [
                "CUDAExecutionProvider",
                "CPUExecutionProvider"
            ]
        else:
            providers = [
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
