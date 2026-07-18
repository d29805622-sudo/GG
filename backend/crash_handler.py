import traceback
import datetime


def save_crash(error):

    filename = (
        "crash_"
        +
        datetime.datetime.now()
        .strftime("%Y%m%d_%H%M%S")
        +
        ".log"
    )

    with open(
        filename,
        "w",
        encoding="utf-8"
    ) as f:

        f.write(
            traceback.format_exc()
        )
