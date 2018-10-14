import torch
import torchvision
import torchvision.transforms as transforms

import matplotlib.pyplot as plt
import numpy as np

import torch.nn as nn
import torch.nn.functional as F

import torch.optim as optim

TRAIN_BATCH = 100
TEST_BATCH = 80
EPOCH = 100
PRINT_FREQ = 10 #Every n-mini batched

##########################################################################

transform = transforms.Compose(
    [transforms.ToTensor(),
     transforms.Normalize((0.5, 0.5, 0.5), (0.5, 0.5, 0.5))])

trainset = torchvision.datasets.CIFAR10(root='./data', train=True,
                                        download=True, transform=transform)
trainloader = torch.utils.data.DataLoader(trainset, batch_size=TRAIN_BATCH,
                                          shuffle=False, num_workers=2)

testset = torchvision.datasets.CIFAR10(root='./data', train=False,
                                       download=True, transform=transform)
testloader = torch.utils.data.DataLoader(testset, batch_size=TEST_BATCH,
                                         shuffle=False, num_workers=2)

classes = ('plane', 'car', 'bird', 'cat',
           'deer', 'dog', 'frog', 'horse', 'ship', 'truck')

##########################################################################

device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
print(device)
#Print cuda if we can use cuda

##########################################################################

class Net(nn.Module):
    def __init__(self):
        super(Net, self).__init__()         #(3, 32, 32)
        self.conv1 = nn.Conv2d(3, 5, 5)     #(5, 28, 28)
        self.pool = nn.MaxPool2d(4, 4)      #(5, 7, 7)
        self.fc1 = nn.Linear(5 * 7 * 7, 45)
        self.fc2 = nn.Linear(45, 10)
        #self.fc3 = nn.Linear(30, 10)

    def forward(self, x):
        x = self.pool(F.relu(self.conv1(x)))
        x = x.view(-1, 5 * 7 * 7)
        x = F.relu(self.fc1(x))
        #x = F.relu(self.fc2(x))
        x = self.fc2(x)
        return x

net = Net()
if torch.cuda.is_available():
    net = net.cuda()
#net.to(device)
print(net)
pytorch_total_params = sum(p.numel() for p in net.parameters())
print('Total Params:', pytorch_total_params)

##########################################################################

criterion = nn.CrossEntropyLoss()
optimizer = optim.Adam(net.parameters(), lr=0.01, betas=(0.9, 0.999))

loss_graph = {}
loss_graph_color = ['r', 'g', 'b', 'm', 'k']
test_accuracy_graph = []

max_i = 0
for epoch in range(EPOCH):  # loop over the dataset multiple times
    loss_graph[str(epoch)] = {}
    loss_graph[str(epoch)]['loss_index'] = []
    loss_graph[str(epoch)]['hold_loss'] = []

    running_loss = 0.0
    for i, data in enumerate(trainloader, 0):
        # get the inputs
        inputs, labels = data
        if torch.cuda.is_available():
            inputs, labels = inputs.cuda(), labels.cuda()

        # zero the parameter gradients
        optimizer.zero_grad()

        # forward + backward + optimize
        outputs = net(inputs)
        loss = criterion(outputs, labels)
        loss.backward()
        optimizer.step()

        # print statistics
        running_loss += loss.item()
        if i % PRINT_FREQ == PRINT_FREQ-1:
            print('[%d, %5d] loss: %.3f' %
                  (epoch + 1, i + 1, running_loss / PRINT_FREQ))
            loss_graph[str(epoch)]['loss_index'].append(max_i*epoch + i + 1)
            loss_graph[str(epoch)]['hold_loss'].append(running_loss / PRINT_FREQ)
            running_loss = 0.0
            max_i = (i if i > max_i else max_i)

##########################################################################

    correct = 0
    total = 0
    with torch.no_grad():
        for data in testloader:
            images, labels = data
            if torch.cuda.is_available():
                images, labels = images.cuda(), labels.cuda()
            #images, labels = images.to(device), labels.to(device)

            outputs = net(images)
            #_, predicted = torch.max(outputs, 1)
            _, predicted = torch.topk(outputs, 5, 1)
            total += labels.size(0)
            #correct += (labels == predicted).sum().item()
            correct += sum(1 if l in predicted[l_index] else 0 for l_index, l in enumerate(labels))

    print('Accuracy of the network on %d epoch for the 10000 test images: %d %%' % (
        epoch+1, 100 * correct / total))
    test_accuracy_graph.append(100*correct/total)
    print('Correct ', correct)
    print('Total ', total)

##########################################################################

print('Finished Training')
for epoch in range(EPOCH):
    plt.plot(np.array(loss_graph[str(epoch)]['loss_index']),
        np.array(loss_graph[str(epoch)]['hold_loss']),
        loss_graph_color[epoch%len(loss_graph_color)])
plt.show()

plt.plot(np.array(test_accuracy_graph))
plt.show()

##########################################################################

# class_correct = list(0. for i in range(10))
# class_total = list(0. for i in range(10))
# with torch.no_grad():
#     for data in testloader:
#         images, labels = data
#         if torch.cuda.is_available():
#             images, labels = images.cuda(), labels.cuda()
#         #images, labels = images.to(device), labels.to(device)
#         outputs = net(images)
#         #_, predicted = torch.max(outputs, 1)
#         _, predicted = torch.topk(outputs, 5, 1)
#         c = list(1 if l in predicted[l_index] else 0 for l_index, l in enumerate(labels))
#         if torch.cuda.is_available():
#             c = torch.cuda.FloatTensor(c)
#         else:
#             c= torch.FloatTensor(c)
#         #c = (labels == predicted).squeeze()
#         for i in range(TEST_BATCH):
#             label = labels[i]
#             class_correct[label] += c[i].item()
#             class_total[label] += 1


# for i in range(10):
#     print('Accuracy of %5s : %2d %%' % (
#         classes[i], 100 * class_correct[i] / class_total[i]))

##########################################################################

from torch.autograd import Variable
from PIL import Image
from os import listdir
from os.path import isfile, join
onlyfiles = [join('./testing', f) for f in listdir('./testing') if isfile(join('./testing', f))]

def image_loader(loader, image_name):
    """load image, returns cuda tensor"""
    image = Image.open(image_name)
    image = loader(image).float()
    image = Variable(image, requires_grad=True)
    if torch.cuda.is_available():
        return image.cuda()
    else:
        return image

with torch.no_grad():
    images = []
    for file_name in onlyfiles:
        image = image_loader(transform, file_name)
        images.append(image)
    outputs = net(torch.stack(images))
    _, predicted = torch.topk(outputs, 5, 1)

    for index, topk in enumerate(predicted):
        print(onlyfiles[index], ', '.join(classes[class_index] for class_index in topk))