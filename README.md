# ship-detector

Detects ship bounding boxes in a given image strip using a trained CNN classifier to deploy on Protogen-generated region proposals.

<img src='images/ship-detector.png' width=700>

## Run

Here we run through a sample execution of the ship-detector task. We will find all ships in an image over New York. All of the input data is available in the S3 locations specified below.


1. Within an iPython terminal create a GBDX interface an specify the task input location:  

    ```python
    from gbdxtools import Interface
    from os.path import join
    import uuid

    gbdx = Interface()

    input_location = 's3://gbd-customer-data/58600248-2927-4523-b44b-5fec3d278c09/platform-stories/ship-detector/'
    ```

2. Create a task instance and set the required [inputs](#inputs):  

    ```python
    ship_task = gbdx.Task('chip-detector')
    ship_task.inputs.pan_image = join(input_location, 'pan_image')
    ship_task.inputs.ms_image = join(input_location, 'ms_image')
    ```

3. Initialize a workflow and specify where to save the output:  

    ```python
    ship_wf = gbdx.Workflow([ship_task])
    random_str = str(uuid.uuid4())
    output_location = join('platform-stories/trial-runs', random_str)

    ship_wf.savedata(deploy_task.outputs.results, join(output_location, 'ship_detections'))
    ```

5. Execute the workflow:  

    ```python
    ship_wf.execute()
    ```

6. Track the status of the workflow as follows:

    ```python
    ship_wf.status
    ```


## Inputs

GBDX input ports can only be of "Directory" or "String" type. Booleans, integers and floats are passed to the task as strings, e.g., "True", "10", "0.001".

| Name  | Type | Description | Required |
|---|---|---|---|
| ms_image | directory | Contains a multispectral GeoTiff image in which to detect ships. This directory should only contain one image, otherwise a file will be selected arbitrarily. | True |
| pan_image | directory | Contains a pansharpened version of ms_image. This directory should only contain one image, otherwise a file will be selected arbitrarily. | True |

## Output Ports

| Name  | Type | Description |
|---|---|---|
| results | directory | Contains a geojson with protogen region proposals, each given a classification of 0 (no ship) or 1 (ship). |


## Development

### Build the Docker Image

You need to install [Docker](https://docs.docker.com/engine/installation).

Clone the repository:

```bash
git clone https://github.com/platformstories/ship-detector
```

Then

```bash
cd ship-detector
docker build -t ship-detector .
```

### Try out locally

Create a container in interactive mode and mount the sample input under `/mnt/work/input/`:

```bash
docker run -v full/path/to/sample-input:/mnt/work/input -it ship-detector
```

Then, within the container:

```bash
python /ship-detector.py
```

### Docker Hub

Login to Docker Hub:

```bash
docker login
```

Tag your image using your username and push it to DockerHub:

```bash
docker tag ship-detector yourusername/ship-detector
docker push yourusername/ship-detector
```

The image name should be the same as the image name under containerDescriptors in ship-detector.json.

Alternatively, you can link this repository to a [Docker automated build](https://docs.docker.com/docker-hub/builds/). Every time you push a change to the repository, the Docker image gets automatically updated.
### Register on GBDX

In a Python terminal:
```python
from gbdxtools import Interface
gbdx=Interface()
gbdx.task_registry.register(json_filename="ship-detector.json")
```

Note: If you change the task image, you need to reregister the task with a higher version number in order for the new image to take effect. Keep this in mind especially if you use Docker automated build.

