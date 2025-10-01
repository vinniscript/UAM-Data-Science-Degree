import numpy as np
from sklearn.preprocessing import TargetEncoder
X = np.array([["dog"] * 20 + ["cat"] * 30 + ["snake"] * 38], dtype=object).T
print(X)
y = [90.3] * 5 + [80.1] * 15 + [20.4] * 5 + [20.1] * 25 + [21.2] * 8 + [49] * 30
print(y)
enc_auto = TargetEncoder(smooth="auto")
X_trans = enc_auto.fit_transform(X, y)
print(X_trans)