<p align="center"; font-size=2em; font-weight="bold">pictoPredictor</p>
<p align="center"> Using Transformers to enhance human communication. </p>

![](https://img.shields.io/badge/huggingface-transformers-blue)
![](https://img.shields.io/badge/python-3.10-blue)
![](https://img.shields.io/badge/Made%20with-Love-red)



<!-- ![](./images/readme_image.png) -->
<p align="center">
<img src="./images/readme_image.png" alt="readme_image" style="width:300px;height:300px;" />
</p>






## Table of Contents

- [pictoPredictor](#pictopredictor)
  - [Table of Contents](#table-of-contents)
  - [Description](#description)
  - [Installation](#installation)
  - [Usage](#usage)
  - [Folder structure](#folder-structure)
  - [Contributing](#contributing)
  - [License](#license)

## Description
This project provides a pictogram predictor for Augmentative and Alternative Communication (AAC) systems.
There's some work that has done this (e.g., [PictoBERT: Transformers for next pictogram prediction](https://www.sciencedirect.com/science/article/abs/pii/S095741742200611X)), but this paper's approach requires to train a BERT model from scratch, changing BERT's input embeddings to allow word-sense usage instead of words (i.e., Masked Word-Sense Language Modeling) and using an annotated corpus for training. 

The downsides of this (great) paper ([code available here] (https://github.com/jayralencar/pictoBERT)) are: 

1. This work is for English pictogram prediction --> We are looking for a Spanish solution.  
2. Requires an annotated corpus. 
3. Requires full training of a BERT model. 
4. The model doesn't distinguish between different pictogram vocabularies for AAC (patients may have different pictogram vocabularies -set of possible pictograms that can be used- depending on the state of their cognitive abilities)

The approach taken in this project is, with the hopes of being more pragmatic and more easily deployed, the following:

**Base MVP**

1. Grab an already fast [BERT](https://arxiv.org/abs/1810.04805) model that works in spanish. That is, a [DistilBERT](https://arxiv.org/abs/1910.01108) that is already finetuned using a spanish corpus. e.g., [dccuchile/distilbert-base-spanish-uncased](https://huggingface.co/dccuchile/distilbert-base-spanish-uncased) 
2. Build a pictogram prediction "filter". Given a pictogram vocabulary, remove from the prediction those pictograms that do NOT appear in the vocabulary.
3. Build Gradio App and deploy. 

**Improvements over MVP**

1. Improve model predictions. This is achieved by finetuning on a dataset that effectively shifts the probability mass of each possible pictogram towards pictograms that are likely to be used by a patient. 

    - A dataset that achieves this shifting means a dataset of patient conversations, and to the best of my knowledge, this dataset does not exist. 
    Thus, we have to generate a synthetic dataset: To do this, we prompt a Llama2 model to generate 10 sentences given each possible pictogram in a given patient's vocabulary (see `src/generate_synthetic_dataset.py`) and then finetune the model on this dataset (see `src/finetune_model.py`)

1. Improve the model/program speed and memory requirements by:
    - Prepare the model to run on edge with [Tensorflow Lite](https://www.tensorflow.org/lite)

    - Write the whole pictogram predictor app in C++




**Downsides of this approach**

1. Missing pictograms in the prediction: 
    - With this approach, we cannot predict multi-word pictograms (e.g., 'buen provecho' or 'es gracioso', see `data/lista-pictogramas`). Thus, some pictograms (the  multi-word ones) are never going to appear in the predictions. 

    - Some spanish pictograms are not contained in DistilBERT's vocabulary. Thus those pictograms also won't appear in the predictions.




## Installation
1. Clone the repository: 
```bash
git clone https://github.com/tatakof/pictoPredictor.git
cd pictoPredictor
conda create --name myenv
conda activate myenv
pip install -r requirements.txt
```

## Usage
To run the whole pipeline (clean data, train, launch app):
```bash
python main.py
```

To launch the Gradio app
```bash
python app.py
```

## Folder structure
The `src` folder contains up to date and clean code. Use this for your own projects. 
The `nbs` folder may contain outdated code and is not clean. It may not run out of the box and might not be the easiest thing to understand. However, they may contain useful information for some people (mainly if you haven't done any NLP before), so inspect them if you need. Note: Some of those nbs where used in Google Colab, so they might not run locally without some mods. 

## Contributing
1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## License
Apache 2.0


