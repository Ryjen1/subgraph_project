#!/bin/bash

# Subgraph deployment script for NECTR Staking Contract

echo "🚀 Starting subgraph deployment process..."

# Check if graph CLI is installed
if ! command -v graph &> /dev/null; then
    echo " Graph CLI not found. Installing..."
    npm install -g @graphprotocol/graph-cli
fi

# Generate code from schema and ABI
echo "📝 Generating TypeScript types..."
npm run codegen

if [ $? -ne 0 ]; then
    echo " Code generation failed!"
    exit 1
fi

# Build the subgraph
echo " Building subgraph..."
npm run build

if [ $? -ne 0 ]; then
    echo " Build failed!"
    exit 1
fi

echo " Subgraph built successfully!"

# Check deployment target
if [ "$1" = "local" ]; then
    echo " Deploying to local Graph Node..."
    
    # Create subgraph on local node
    npm run create-local
    
    # Deploy to local node
    npm run deploy-local
    
    if [ $? -eq 0 ]; then
        echo "✅ Successfully deployed to local Graph Node!"
        echo "📊 Subgraph available at: http://localhost:8000/subgraphs/name/staking-subgraph"
    else
        echo "❌ Local deployment failed!"
        exit 1
    fi
    
elif [ "$1" = "studio" ]; then
    echo "☁️  Deploying to The Graph Studio..."
    
    # Check if auth token is set
    if [ -z "$GRAPH_AUTH_TOKEN" ]; then
        echo "❌ GRAPH_AUTH_TOKEN environment variable not set!"
        echo "Please set your Graph Studio deploy key:"
        echo "export GRAPH_AUTH_TOKEN=your_deploy_key_here"
        exit 1
    fi
    
    # Deploy to studio (deploy key is passed in the npm script)
    npm run deploy
    
    if [ $? -eq 0 ]; then
        echo "✅ Successfully deployed to The Graph Studio!"
        echo "📊 Check your subgraph at: https://thegraph.com/studio/"
    else
        echo "❌ Studio deployment failed!"
        exit 1
    fi
    
else
    echo "📋 Usage: ./deploy.sh [local|studio]"
    echo ""
    echo "Options:"
    echo "  local   - Deploy to local Graph Node"
    echo "  studio  - Deploy to The Graph Studio"
    echo ""
    echo "For studio deployment, set GRAPH_AUTH_TOKEN environment variable first:"
    echo "export GRAPH_AUTH_TOKEN=your_deploy_key_here"
    exit 1
fi

echo "🎉 Deployment completed!"