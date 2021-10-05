#! /bin/bash

# Runs the "345M" parameter model

GPUS_PER_NODE=8
# Change for multinode config
MASTER_ADDR=localhost
MASTER_PORT=6000
NNODES=1
NODE_RANK=0
WORLD_SIZE=$(($GPUS_PER_NODE*$NNODES))

DATA_PATH=/home/chenchang/dataset/fastmoe/my-gpt2_text_document
CHECKPOINT_PATH=checkpoints/gpt2_345m

DISTRIBUTED_ARGS="--nproc_per_node $GPUS_PER_NODE --nnodes $NNODES --node_rank $NODE_RANK --master_addr $MASTER_ADDR --master_port $MASTER_PORT"

python -m torch.distributed.launch $DISTRIBUTED_ARGS \
       pretrain_gpt.py \
       --tensor-model-parallel-size 8 \
       --pipeline-model-parallel-size 1 \
       --num-layers ${num_layers:-16} \
       --hidden-size ${hidden_size:-1024} \
       --num-attention-heads ${num_heads:-16} \
       --micro-batch-size ${batch_size:-8} \
       --global-batch-size 8 \
       --seq-length 1024 \
       --max-position-embeddings 1024 \
       --train-iters 500000 \
       --lr-decay-iters 320000 \
       --save $CHECKPOINT_PATH \
       --load $CHECKPOINT_PATH \
       --data-path $DATA_PATH \
       --vocab-file /home/chenchang/dataset/fastmoe/gpt2-vocab.json \
       --merge-file /home/chenchang/dataset/fastmoe/gpt2-merges.txt \
       --data-impl mmap \
       --split 949,50,1 \
       --distributed-backend nccl \
       --lr 0.00015 \
       --lr-decay-style cosine \
       --min-lr 1.0e-5 \
       --weight-decay 1e-2 \
       --clip-grad 1.0 \
       --lr-warmup-fraction .01 \
       --checkpoint-activations \
       --log-interval 1 \
       --save-interval 100000 \
       --eval-interval 1000 \
       --eval-iters 10 \
	--fmoefy \
       --balance-strategy gshard
       #--fp16