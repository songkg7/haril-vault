---
title: B-Tree
date: 2023-10-04 23:27:00 +0900
aliases: 
tags:
  - tree
  - algorithm
  - binary
  - java
categories: 
updated: 2023-10-04 23:27:16 +0900
---

B-트리는 정렬된 데이터를 유지하며 효율적인 삽입, 삭제 및 검색 작업을 가능하게 하는 자기 균형 검색 트리 데이터 구조입니다. B-트리는 대용량 데이터를 저장하기 위해 데이터베이스 시스템과 파일 시스템에서 일반적으로 사용됩니다.

B-트리는 일정 수의 키와 자식 노드를 포함하는 노드로 구성되어 있습니다. 각 노드에 있는 키의 수는 일반적으로 최소 차수(일반적으로 반 정도)와 최소 차수의 두 배 사이입니다.

B-트리의 루트 노드에는 적어도 하나의 키가 있으며, 다른 비루트 노드에는 최소 ceil(최소 차수/2)개의 키가 있습니다. 각 노드의 키는 오름차순으로 정렬되어 있으며, 이진 탐색을 통한 효율적인 검색이 가능합니다.

새로운 키를 B-트리에 삽입하기 위해서는 해당 리프 노드가 발견될 때까지 트리를 위에서 아래로 순회합니다. 리프 노드에 충분한 공간이 있는 경우, 정렬된 순서를 유지하면서 올바른 위치에 삽입됩니다. 리프 노드가 이미 가득 찬 경우, 중간 키를 부모 노드로 승진시켜 두 개의 노드로 분할해야 합니다. 이 과정은 필요한 모든 분할이 수행될 때까지 재귀적으로 계속됩니다.

마찬가지로 B-트리에서 키를 삭제할 때는 이진 탐색을 사용하여 트리 내에서 해당 키를 먼저 찾습니다. 키가 리프 노드에 있는 경우 간단히 제거할 수 있습니다. 그렇지 않은 경우, 해당 키는 선행자나 후속자(삭제된 키보다 작은 가장 큰 키 또는 삭제된 키보다 큰 가장 작은 키)와 교체해야 합니다. 교체된 키는 리프 노드에 있어야 하며, 트리에서 균형을 깨뜨리지 않고 쉽게 삭제할 수 있습니다.

B-트리의 중요한 속성 중 하나는 모든 리프 노드가 동일한 수준에 있다는 것으로, 트리 내의 어떤 요소에도 효율적으로 액세스할 수 있도록 보장합니다. 또한 자기 균형적인 성질 때문에 B-트리의 작업은 평균 시간 복잡도가 O(log n)이 되며, 여기서 n은 트리 내 요소의 수입니다.

전반적으로 B-트리는 대용량 데이터의 효율적인 저장 및 검색이 필요한 시나리오에서 널리 사용됩니다. 균형 잡힌 구조와 동적 데이터에 대한 적응 능력으로 인해 데이터베이스, 파일 시스템 및 인덱싱 구조를 포함한 다양한 응용 분야에 적합합니다.

## Implement

Here is an example implementation of a B-Tree in Java:

```java
class BTreeNode {
    int[] keys;
    int t;
    BTreeNode[] childNodes;
    int numKeys;
    boolean leaf;

    public BTreeNode(int t, boolean leaf) {
        this.t = t;
        this.leaf = leaf;
        keys = new int[2 * t - 1];
        childNodes = new BTreeNode[2 * t];
        numKeys = 0;
    }
}

class BTree {
    private BTreeNode root;
    private int t;

    public BTree(int t) {
        this.t = t;
        root = new BTreeNode(t, true);
    }

    public void insert(int key) {
        if (root.numKeys == (2 * t - 1)) {
            BTreeNode newNode = new BTreeNode(t, false);
            newNode.childNodes[0] = root;
            root = newNode;

            splitChild(newNode, 0);
            insertNonFull(newNode, key);
        } else {
            insertNonFull(root, key);
        }
    }

    private void insertNonFull(BTreeNode node, int key) {
        int i = node.numKeys - 1;

        if (node.leaf) {
            while (i >= 0 && key < node.keys[i]) {
                node.keys[i + 1] = node.keys[i];
                i--;
            }
            node.keys[i + 1] = key;
            node.numKeys++;
        } else {
            while (i >= 0 && key < node.keys[i]) {
                i--;
            }

            i++;
            if (node.childNodes[i].numKeys == (2 * t - 1)) {
                splitChild(node, i);
                if (key > node.keys[i]) {
                    i++;
                }
            }
            
            insertNonFull(node.childNodes[i], key);
        }
    }

    private void splitChild(BTreeNode parentNode, int index) {
        BTreeNode newNode = new BTreeNode(t, parentNode.childNodes[index].leaf);
        BTreeNode childNode = parentNode.childNodes[index];

        for (int i = 0; i < t - 1; i++) {
            newNode.keys[i] = childNode.keys[i + t];
        }

        if (!childNode.leaf) {
            for (int i = 0; i < t; i++) {
                newNode.childNodes[i] = childNode.childNodes[i + t];
            }
        }

        for (int i = parentNode.numKeys; i > index; i--) {
            parentNode.childNodes[i + 1] = parentNode.childNodes[i];
        }

        parentNode.childNodes[index + 1] = newNode;

        for (int i = parentNode.numKeys - 1; i >= index; i--) {
            parentNode.keys[i + 1] = parentNode.keys[i];
        }

        parentNode.keys[index] = childNode.keys[t - 1];
        
        newNode.numKeys = t - 1;
        childNode.numKeys = t - 1;
        
        parentNode.numKeys++;
    }
    
    public boolean search(int key) {
         return search(root, key);
    }

    private boolean search(BTreeNode node, int key) {
         int i = 0;
         while (i < node.numKeys && key > node.keys[i]) {
             i++;
         }
         
         if (i < node.numKeys && key == node.keys[i]) {
             return true;
         } else if (node.leaf) {
             return false;
         } else {
             return search(node.childNodes[i], key);
         }
    }
}
```

This implementation provides the basic functionalities of insertion and searching in a B-Tree. You can create a new BTree object with a specified minimum degree `t`, and then use the `insert` method to add keys to the tree. The `search` method allows you to check if a certain key is present in the tree.

Keep in mind that this is a simplified implementation for demonstration purposes. In practice, you may need to add additional methods for deletion and other operations, as well as handle edge cases and error conditions.
