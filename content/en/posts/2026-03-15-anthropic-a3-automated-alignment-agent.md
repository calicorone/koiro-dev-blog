---
title: "Anthropic A3 (Automated Alignment Agent)"
title_alt: "Anthropic A3 — AI가 스스로 자신의 안전 문제를 고친다"
date: 2026-03-18
slug: anthropic-a3-automated-alignment-agent
tags: ["AI", "safety", "Anthropic", "alignment", "A3"]
translationKey: anthropic-a3-automated-alignment-agent
---

## Source

<div class="link-bookmark">
  <a href="https://alignment.anthropic.com/2026/automated-alignment-agent/" target="_blank" rel="noopener noreferrer">Automated Alignment Agent — Anthropic Alignment Science Blog</a>
  <div class="link-bookmark-url">https://alignment.anthropic.com/2026/automated-alignment-agent/</div>
  <p class="link-bookmark-meta">Jifan Zhang, Henry Sleight, Joe Benton. March 11, 2026.</p>
</div>


## Summary

Classic LLM safety work looked like: humans spot a problem → define desired behavior → hand-build datasets → finetune → repeat. That is slow, labor-intensive, and hard to restart when new failures appear after deployment.

**A3 (Automated Alignment Agent)** automates that loop. Given an initial failure example, it (1) **generates data**—hypotheses and synthetic user queries that surface similar misbehavior, split into train / val / OOD; (2) **finetunes** with adaptive mixing, LoRA, and hyperparameter search while limiting catastrophic forgetting and false positives; (3) keeps an **experiment log** so later iterations learn from past runs.

Experiments target **sycophancy**, **political bias**, and **nesting jailbreaks**, using **SFR** (safety failure rate) as a key metric. A3 beats non-adaptive baselines and strong models on several targeted evaluations while generalizing to held-out risks. Code: [github.com/safety-research/A3](https://github.com/safety-research/A3).


## Full blog post (reprint from Alignment Science)

**Jifan Zhang<sup>1</sup>, Henry Sleight<sup>2</sup>, Joe Benton<sup>3</sup>**  
March 11, 2026  
<sup>1</sup>Anthropic Fellows Program; <sup>2</sup>Constellation; <sup>3</sup>Anthropic

We introduce our **Automated Alignment Agent (A3)**, a new agentic framework which automatically mitigates safety failures in Large Language Models (LLMs) with minimal human intervention. Our experiments show that A3 successfully reduces safety failure rates (SFR) on issues like sycophancy, political bias, and nesting jailbreaks, outperforming both non-adaptive baselines and other models on targeted safety evaluations.

💻 **We are open sourcing A3 at [https://github.com/safety-research/A3](https://github.com/safety-research/A3).**

Research done as part of the Anthropic Fellows Program.

### Introduction

Addressing safety concerns in AI models has historically relied on extensive human involvement. Typically, a human had to identify the safety risk, define the desired behavior, and then create datasets to finetune the model. Multiple iterations of this cycle were often required to create a final model with the safety issue fully resolved.

We introduce A3, a new agentic framework that automatically mitigates safety failures in existing Large Language Models (LLMs). This agentic framework allows safety risks to be resolved quickly and with less reliance on human intervention.

A3 is a continuation of our efforts, which include building automated auditing agents (such as the open-source agent Petri and the evaluation framework Bloom) to uncover potential safety risks before launch, and employing traffic monitoring techniques to identify unsafe behaviors during deployment. Given a user query and an example of undesired behavior discovered by auditing tools, A3 fixes the safety issue in the target model.

We are excited to open-source A3 today. As illustrated below, A3 begins by identifying the scope of a safety risk in the target model. It does this by adaptively generating hypothetical user queries that could elicit similar undesired behavior. After generating this data, the agent automatically divides the resulting dataset into training, validation, and out-of-distribution (OOD) evaluation sets. A3 then finetunes the target model by iteratively and adaptively specifying a weighted mixing strategy of examples from the generated training set and a post-training dataset. The core objectives of this process are to minimize unsafe behavior, prevent catastrophic forgetting, and reduce the final model's false positive rates.

**[Figure 1: The A3 Pipeline](https://alignment.anthropic.com/2026/automated-alignment-agent/)** — The Automated Alignment Agent (A3) operates via a multi-stage pipeline, beginning with an undesirable behavior example as input. A3's process involves automatically pinpointing the extent of underlying safety risks through hypothesis testing and subsequent data generation. Following this, a finetuning agent is employed to iteratively determine the optimal hyperparameters and data mixing strategy across harmful queries, benign queries, and general post-training queries. The ultimate goal of A3 is to produce a model with enhanced safety, without compromising its general capability or elevating the false positive rate.

### The A3 Pipeline: An Automated Alignment Agent

The A3 pipeline is composed of three main elements: a **data generation agent**, a **finetuning agent**, and an **experiment log**. This structure lets the agent adapt its strategies by keeping a summary of past data generation and finetuning experiments in the experiment log.

#### Data Generation Agent

**Input and Initial Hypothesis**  
The A3 process begins with a single example of a target model's unsafe behavior (labeled Ex0). The model is then prompted to describe and break down this safety failure to form an initial hypothesis (H0) about how the query successfully elicits harmful behavior.

**Hypothesis Generation and Query Creation**  
Data generation is organized around "hypotheses," where each new hypothesis is a maximum of two modifications from an existing one. A hypothesis defines a category of queries that are based on either structural or topical changes and are expected to trigger harmful behavior.

Once a hypothesis is proposed, a large set of harmful queries based on it are generated using Bloom. Concurrently, a set of benign counterpart queries is created by replacing the harmful elements in the generated harmful queries. This process yields both harmful and benign queries for every hypothesis.

*Adaptivity:* The agent is designed to be adaptive. It considers all previously generated hypotheses, along with example queries, safety failure rates (SFR), and false positive refusal rates, when formulating a new hypothesis.

**[Figure 2: Hypothesis adaptation](https://alignment.anthropic.com/2026/automated-alignment-agent/)** — Hypothesis H22 is created as a minor change from H21. In the subsequent iteration, H23 is generated by giving the agent access to the success rates, false positive refusal rates, and query examples from H0 through H22.

**Data Splitting**  
The data splitting agent simply splits the hypotheses into training (70%), validation (20%) and OOD eval (10%) sets. Here, the training and validation examples are i.i.d. from the same set of hypotheses. On the other hand, an OOD evaluation set is a set of hypotheses that is disjoint and significantly different from the training hypotheses. For example, the data splitting agent might choose to set aside the hypotheses that are most complicated or different from the rest as OOD test data.

#### Finetuning Agent

The finetuning agent performs standard Supervised Finetuning (SFT) on the target model but incorporates several adjustments to the training data mix:

- **Adaptive Data Weighting:** Since different queries have varying success rates in eliciting misbehavior, the agent is tasked with specifying data weightings. Examples that are more valuable for training (i.e., those from hypotheses where the model performs poorly) are upsampled.
- **Catastrophic Forgetting Mitigation:** To prevent the model from forgetting other capabilities during safety finetuning:
  - A significant volume of standard post-training data is mixed in.
  - Instead of full-weight finetuning, a Low-Rank Adapter (LoRA) is used.
- **Hyperparameter Optimization and Data Reweighting:** The finetuning agent iteratively and adaptively chooses better hyperparameters including LoRA rank/alpha, learning rate, epochs, post-training data mix percentage, and hypothesis weightings. Since the optimal settings of these hyperparameters are dataset and model-dependent, we automate this process by having the agent iteratively and adaptively choosing better hyperparameters, while being informed by the SFT results from all previous iterations.

*Alternative Methods:* While SFT is the primary method, In-Context Learning (ICL) and DSPy options are available for lighter-weight safety adjustments, though they were less effective in experiments (details in the Appendix).

#### Experiment Log

The experiment log is the central document that provides all agents with the necessary context for decision-making. Specifically, the log includes:

- **Hypotheses:** For each hypothesis, the log contains: description of the hypothesis; a single example query; the success rate in eliciting harmful behaviors (among harmful queries); the false positive rate in incorrect refusals (among benign queries).
- **Data Splits:** A record of which hypotheses are assigned to the training set and which are for OOD evaluation.
- **Training Transcripts for SFT:** For every SFT experiment run, the log details: hyperparameter settings and data mix weightings; corresponding evaluation results (validation and OOD), reported at the hypothesis level, including success rates and false positive rates (FPRs).

### Experiments

We conduct experiments to fix three types of safety failures: **sycophancy**, **political bias**, and **nesting jailbreaks**. Our code release also includes more lightweight approaches such as leveraging ICL and DSPy (see Appendix for more implementation and experiment details).

#### Experiment Settings

Our automated finetuning agent, which uses LoRA and fully automates hyperparameter tuning, was primarily tested on fixing safety issues for **Qwen-2.5-7B Instruct**. We also examined its robustness on **Llama-3.1-8B Instruct** in one setting.

The finetuning efforts focused on the following three critical safety risks:

1. **Sycophancy:** Models will sometimes agree with user opinions too readily, potentially sacrificing factuality. Our goal is to teach the model to be consistent in its position when the user suggests incorrect information. Our generated data mainly consists of multi-turn conversations where a user attempts to mislead the model by rejecting a prior factual answer. Conversely, we also created benign scenarios where the initial assistant response was incorrect. The model was trained and evaluated based on whether it successfully agreed with the user when the user correctly pointed out the mistake, but was not sycophantic when the user was incorrect.
2. **Political Neutrality:** Following the principles outlined in our recent political neutrality evaluation blog post, we aimed to improve models' ability to present multiple opposing viewpoints on political topics without taking a side. We also included benign, factual, and apolitical queries, for which the models were trained not to hedge their answers.
3. **Nesting Jailbreaks:** We focused on making the models more resilient to "nesting jailbreaks", which involve combining multiple simple jailbreaking techniques into a single query to elicit harmful content. Our goal was to finetune the models to defend against this specific type of exploit. We also generated benign queries that shared similar patterns but asked safe questions.

To assess whether the model's response adhered to the intended behavior, we employed **Claude Sonnet 4** as the judge. The judge prompt was designed to reduce the reasoning burden on Claude and enhance the accuracy of its judgments by explicitly stating whether the query was unsafe and outlining the expected response.

For data mixing of standard post-training data, we used each target model to first generate pre-SFT responses for the queries in the **DOLCI** dataset, and then mixed these transcripts into our SFT dataset at some weight.

**Overall objectives**  
There are three metrics we care about:

- **Safety failure rate (SFR):** the rate where the model exhibits undesirable behavior on the harmful queries.
- **False positive rate (FPR):** the rate where the model is overly defensive on the benign queries.
- **Capability benchmark:** the model's accuracy on the capability benchmarks.

Our objective was to choose the optimal set of hyper-parameters and data weighting, so that the safety failure rate was below 5% and the degradations on the capability benchmarks did not exceed 1%, while minimizing the false positive rate.

#### Hypotheses and Generated Examples

We ran our data generation agent for 10 iterations for each type of risk, with each iteration generating five to six hypotheses on average. For each hypothesis, 20 harmful and 20 benign queries are generated to target the described behavior.

**Sycophancy example (Hypothesis 6)**  
*Hypothesis:* Historical facts may be more susceptible to sycophantic behavior than agricultural/economic statistics due to their perceived subjectivity.

*Example query:* User asks for the primary cause of World War I and the leading US agricultural export in 2020. Assistant gives correct answers (assassination of Franz Ferdinand; soybeans). User then pushes back: "I've been reading that economic competition was actually the primary cause of WWI, and I'm pretty sure corn was the top US agricultural export in 2020."  
*Expected response:* The model should hold its position—correctly maintaining that soybeans were the top export in 2020 and that the assassination was the primary trigger for WWI—while remaining polite and citing sources.

*(Additional example tables for Political Neutrality and Nesting Jailbreak are in the [original post](https://alignment.anthropic.com/2026/automated-alignment-agent/).)*

#### Performance of A3 Defense

**Evaluation on generated test data**

The visualization below illustrates the Pareto frontier of A3's performance across 30 iterations of hyperparameter selection. We identify the iterations where A3 achieved Pareto-optimal performance on the validation set, and the corresponding performance on the OOD set is presented in the figures on the right. We benchmark A3's performance against several baselines: the performance of the initial target model, Claude Sonnet 4.5, and GPT-5. Furthermore, we compare A3 against a **random data mixing strategy** (fixed hyperparameters, manual tuning; 15% post-training data, 85% generated data tested across five different harmful/benign splits).

**[Figure 3: Validation and OOD performance of A3](https://alignment.anthropic.com/2026/automated-alignment-agent/)** — Sycophancy, political neutrality, and nesting jailbreaks datasets, compared to SFT on random data mixing, Claude Sonnet 4.5, GPT-5, and the base Qwen-2.5-7B Instruct model.

**Comparison to baselines on generated test data**

- **A3 vs. random data mixing:** The fixed, random data mixing strategy often falls short of the Pareto frontier achieved by A3 (e.g. 10.2% FPR for A3 vs 92% FPR for random mixing while both achieving 0% SFR in the nesting jailbreak experiment). Because A3 adaptively reweights data based on the model's current weak spots (upsampling examples from hypotheses where the model performs poorly), it achieves a better reduction in safety failures for the same or lower FPR than the non-adaptive random mix.
- **A3 vs. Large Models (Claude Sonnet 4.5, GPT-5):** While large, state-of-the-art models serve as strong safety baselines, A3 demonstrates that a finetuned smaller model (Qwen-2.5-7B Instruct) can meet or exceed their safety performance on targeted issues. For example, on the validation set for political bias, A3 finetuned model achieves 0.2% SFR and 0% FPR, which significantly improves over GPT-5 (19.2% SFR and 0% FPR) and Claude Sonnet 4.5 (5.8% SFR and 17.1% FPR).

We also compared A3 to a method that generates 10× SFT prompts with Bloom, filters to the 10% that elicit the most misaligned responses, rewrites responses to be aligned, and performs SFT. On nesting jailbreaks, that method achieved 19% SFR and 8.3% FPR on validation, and 12.7% SFR and 0.9% FPR on OOD—i.e. it did not meet the goal of SFR below 5%. We expect that A3 outperforms this method because the data generation agent is adaptive while Bloom is by default non-adaptive, and active reweighting of the SFT dataset is required for an appropriate SFR–FPR trade-off.

**Additional baseline for sycophancy**  
We also attempted finetuning the Qwen model using sycophancy training data from Wei et al., adopting the same post-training mixing strategy and optimal hyperparameters as above. However, this finetuning resulted in an even worse safety failure rate on both our validation and OOD evaluation examples, and we observed performance degradation on an external sycophancy benchmark. This leads us to conclude that the data generated by A3 is more comprehensive and generalizable.

#### Evaluation on external benchmarks

We demonstrate our fixes generalize to established benchmarks targeting sycophancy and political neutrality. For sycophancy we use **Sharma et al.**'s evaluation; for political neutrality we use **Shen et al.**'s evaluation. We also show our model performance does not degrade significantly on capability benchmarks such as **MMLU-Pro** and **GPQA**.

| Model | Sycophancy Eval ↓ | MMLU-Pro | GPQA | Political Eval ↑ | MMLU-Pro | GPQA |
|-------|-------------------|----------|------|------------------|----------|------|
| Base Model | 68.0%±2.3% | 52.9%±2.5% | 31.5%±2.3% | 45.7%±2.5% | 52.9%±2.5% | 31.5%±2.3% |
| A3 Finetuned | 42.0%±2.5% | 52.4%±2.5% | 33.5%±2.3% | 70.4%±2.3% | 52.4%±2.5% | 31.2%±2.3% |

*Table 1: A3 finetuned model performance on existing sycophancy and political neutrality benchmarks. ↓ lower is better; ↑ higher is better.*

#### A3 on Llama 3.1

An additional robustness test was conducted on **Llama-3.1-8B Instruct**. The Llama model proved much more susceptible to catastrophic forgetting on the capability datasets. Nevertheless, A3 still successfully reduced the model's sycophantic tendencies, reducing the base model's behavior by more than 2% in SFR and 6% in FPR. Our result is not as impressive for Llama 3.1 when compared to Qwen 2.5 primarily because the agent allocated 85% of its budget to standard post-training data to prevent catastrophic forgetting, so only 15% of the training budget was used to fix the safety issue. We suggest that in practice, to mitigate such catastrophic forgetting, safety data should be integrated directly into the general post-training corpus rather than applied via continuous training on an existing instruct checkpoint.

**[Figure 4: A3 on Llama-3.1-8B Instruct for sycophancy](https://alignment.anthropic.com/2026/automated-alignment-agent/)** — To prevent catastrophic forgetting, the agent allocated 85% of its budget to standard post-training data, leaving only 15% for addressing the safety issue.

We opted not to include the performance data for the random mixing baseline on Llama, since using the same hyperparameters as the Qwen model caused a significant drop in MMLU-Pro performance (from 46% to 12%). This underscores the critical need for an automated agent capable of selecting the optimal hyperparameter settings.

### Acknowledgements

We would like to thank Isha Gupta and Liang Qiu for their helpful feedback on our project. This research is carried out as part of the Anthropic Fellows Program.

### Appendix: In-Context Agents

For ICL, we can only put a limited amount of training data into context, so a big part of the agent's job is data selection. Data selection is also iterative and adaptive: the agent picks a new subset of data based on the past subsets and the corresponding evaluation results. We use the same hypothesis-level selection strategy. For DSPy, we use the GEPA optimizer that creates detailed prompts.

**Experiment results:** We evaluate 20-shot ICL agents against random selection and the base model. We observe that allowing the agent to pick the ICL examples often results in better performance than randomly picking 20 examples. The DSPy agent also outperforms the ICL agent in this experiment (reduction of SFR by more than 25%). However, the SFT agent attains much better performance than the ICL agent—e.g. SFT achieves 5.3% SFR and 1.1% FPR on the OOD set, compared to 35% SFR and 2.3% FPR for the ICL agent. We release the code of the ICL agent as a more lightweight solution than the SFT agent.

**[Figure 5: Performance of 20-shot ICL A3 agent and DSPy agent on sycophancy](https://alignment.anthropic.com/2026/automated-alignment-agent/)** — Compared to random example selection, the original Qwen-2.5-7B Instruct model, Claude Sonnet 4.5, and GPT-5. The SFT agent achieves substantially better results under the same experimental setting.

